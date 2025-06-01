//
//  SparklineView.swift
//  iMessageMenu
//
//  Created by gdwyn on 30/05/2025.
//

import SwiftUI

// Updated SparklineView with callback
struct SparklineView: View {
    let data: [Double] // Changed to Double to match your coin data
    @State private var dragX: CGFloat? = nil
    @State private var isDragging = false
    
    // Callback for price updates
    let onPriceUpdate: ((Double, Double) -> Void)?
    
    init(data: [Double], onPriceUpdate: ((Double, Double) -> Void)? = nil) {
        self.data = data
        self.onPriceUpdate = onPriceUpdate
    }
    
    // Convert to CGFloat for drawing
    private var cgFloatData: [CGFloat] {
        data.map { CGFloat($0) }
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let maxData = cgFloatData.max() ?? 1
            let minData = cgFloatData.min() ?? 0
            let stepX = width / CGFloat(cgFloatData.count - 1)
            let points: [CGPoint] = cgFloatData.enumerated().map { index, value in
                let x = CGFloat(index) * stepX
                let y = height - ((value - minData) / (maxData - minData)) * height
                return CGPoint(x: x, y: y)
            }

            // Construct smooth path
            let path: Path = {
                var path = Path()
                guard points.count > 1 else { return path }

                path.move(to: points[0])
                for i in 1..<points.count - 1 {
                    let current = points[i]
                    let next = points[i + 1]
                    let mid = CGPoint(x: (current.x + next.x) / 2,
                                      y: (current.y + next.y) / 2)
                    path.addQuadCurve(to: mid, control: current)
                }
                path.addLine(to: points.last!)
                return path
            }()

            ZStack {
                let activeX = isDragging ? (dragX ?? width) : points.last?.x ?? width
                let trim = trimProgressForPath(for: activeX, on: path)

                path.trim(from: 0, to: 1)
                    .stroke(Color.graphGray, style: StrokeStyle(lineWidth: 3.2, lineCap: .round, lineJoin: .round))
                
                path.trim(from: 0, to: trim)
                    .stroke(Color.black, style: StrokeStyle(lineWidth: 3.2, lineCap: .round, lineJoin: .round))

                // Default dot at the end (when not dragging)
                if !isDragging, let lastPoint = points.last {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 16, height: 16)
                        .position(x: lastPoint.x, y: lastPoint.y)
                }
                
                if isDragging, let lastPoint = points.last {
                    Circle()
                        .fill(.graphGray)
                        .frame(width: 16, height: 16)
                        .position(x: lastPoint.x, y: lastPoint.y)
                }

                // Draggable dot (when dragging)
                if isDragging, let dragX = dragX {
                    let clampedX = min(max(0, dragX), width)
                    if let dotY = yValue(on: path, at: clampedX) {
                        ZStack {
                            // time view
                            VStack(spacing: 0) {
                                Text("\(mockTime(for: clampedX / width))")
                                    .foregroundStyle(.gray)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 8)
                                    .background(.gray.opacity(0.1), in: Capsule())
                                Color.gray
                                    .opacity(0.3)
                                    .frame(width: 1, height: 230)
                            }
                            .position(x: clampedX)
//                            .frame(height: .infinity, alignment: .bottom)
                            .offset(y: 80)

                            Circle()
                                .fill(Color.black)
                                .frame(width: 16, height: 16)
                                .position(x: clampedX, y: dotY)
                        }
                    }
                }
            }
            .contentShape(Rectangle()) // makes entire view tappable
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        isDragging = true
                        dragX = value.location.x
                        
                        // Calculate and send price update
                        let clampedX = min(max(0, value.location.x), width)
                        updatePrice(for: clampedX, width: width)
                    }
                    .onEnded { _ in
                        isDragging = false
                        dragX = nil
                        
                        // Reset to original values by sending nil (handled in parent)
                        onPriceUpdate?(0, 0) // Special values to indicate reset
                    }
            )
        }
    }
    
    /// Updates price based on drag position and calls callback
    private func updatePrice(for x: CGFloat, width: CGFloat) {
        let progress = x / width
        let dataIndex = Int(progress * CGFloat(data.count - 1))
        let clampedIndex = min(max(0, dataIndex), data.count - 1)
        
        // Get the price at this position
        let priceAtPosition = data[clampedIndex]
        
        // Calculate percentage change from the first price point
        guard let firstPrice = data.first, firstPrice > 0 else { return }
        let percentage = ((priceAtPosition - firstPrice) / firstPrice) * 100
        
        // Send update to parent
        onPriceUpdate?(priceAtPosition, percentage)
    }

    /// Approximates the Y position on a path for a given X by trimming and sampling
    func yValue(on path: Path, at x: CGFloat, in resolution: Int = 500) -> CGFloat? {
        let step = 1.0 / CGFloat(resolution)
        for i in 0..<resolution {
            let t1 = CGFloat(i) * step
            let t2 = CGFloat(i + 1) * step

            let p1 = path.trimmedPath(from: t1, to: t1 + step).boundingRect.origin
            let p2 = path.trimmedPath(from: t2, to: t2 + step).boundingRect.origin

            if (p1.x <= x && x <= p2.x) || (p2.x <= x && x <= p1.x) {
                let t = (x - p1.x) / (p2.x - p1.x)
                return p1.y + (p2.y - p1.y) * t
            }
        }
        return nil
    }
    
    /// Find the correct trim value that corresponds to the X position on the curved path
    func trimProgressForPath(for x: CGFloat, on path: Path, resolution: Int = 500) -> CGFloat {
        let step = 1.0 / CGFloat(resolution)
        
        for i in 0..<resolution {
            let t1 = CGFloat(i) * step
            let t2 = CGFloat(i + 1) * step
            
            let p1 = path.trimmedPath(from: t1, to: t1 + step).boundingRect.origin
            let p2 = path.trimmedPath(from: t2, to: t2 + step).boundingRect.origin
            
            // Check if our target X falls between these two points
            if (p1.x <= x && x <= p2.x) || (p2.x <= x && x <= p1.x) {
                // Interpolate to find the exact trim value
                let progress = abs(p2.x - p1.x) < 0.001 ? 0 : (x - p1.x) / (p2.x - p1.x)
                return t1 + (t2 - t1) * progress
            }
        }
        
        // Fallback: return 1 if X is beyond the path
        return x >= path.boundingRect.maxX ? 1 : 0
    }
    
    private func mockTime(for progress: CGFloat) -> String {
        // Calculate actual date based on progress (assuming 7 days of hourly data = 168 data points)
        let hoursAgo = Int((1.0 - progress) * 168) // 7 days * 24 hours
        let date = Calendar.current.date(byAdding: .hour, value: -hoursAgo, to: Date()) ?? Date()
        
        let formatter = DateFormatter()
        
        if Calendar.current.isDateInToday(date) {
            formatter.dateFormat = "h a"
            return "Today \(formatter.string(from: date))"
        } else if Calendar.current.isDateInYesterday(date) {
            formatter.dateFormat = "h a"
            return "Yesterday \(formatter.string(from: date))"
        } else {
            let daysAgo = Calendar.current.dateComponents([.day], from: date, to: Date()).day ?? 0
            formatter.dateFormat = "h a"
            return "\(daysAgo)d ago \(formatter.string(from: date))"
        }
    }
}


#Preview {
    SparklineView(data: [2, 4, 1, 5, 3])
}
