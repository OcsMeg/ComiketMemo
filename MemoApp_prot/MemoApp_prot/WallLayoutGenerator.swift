import Foundation
import CoreGraphics

/// WallLayoutConfig を受け取り、壁サー用の一列机配置を生成する
struct WallLayoutGenerator {
    static func generateLayout(from config: WallLayoutConfig) -> BlockMapLayout {
        guard !config.numbers.isEmpty else {
            return BlockMapLayout(
                desks: [],
                canvasSize: .zero,
                outerFrame: .zero,
                blockLabel: config.block,
                blockLabelPosition: .zero
            )
        }

        let step = config.deskSize + config.spacing
        var desks: [DeskData] = []
        desks.reserveCapacity(config.numbers.count)

        var minX: CGFloat?
        var minY: CGFloat?
        var maxX: CGFloat?
        var maxY: CGFloat?

        for (index, number) in config.numbers.enumerated() {
            let position: CGPoint
            switch config.layoutDirection {
            case .horizontal:
                position = CGPoint(
                    x: config.origin.x + CGFloat(index) * step,
                    y: config.origin.y
                )
            case .vertical:
                position = CGPoint(
                    x: config.origin.x,
                    y: config.origin.y + CGFloat(index) * step
                )
            }

            let formattedNumber = String(format: "%02d", number)
            let canonicalId = "\(config.hall)-\(config.block)-\(formattedNumber)"
            let desk = DeskData(
                id: canonicalId,
                canonicalId: canonicalId,
                hall: config.hall,
                block: config.block,
                number: formattedNumber,
                circleType: .wall,
                position: position,
                size: config.deskSize,
                rotationDegrees: config.rotationDegrees,
                splitDirection: config.splitDirection,
                availableSpaces: config.availableSpaces
            )

            desks.append(desk)

            let deskMaxX = position.x + config.deskSize
            let deskMaxY = position.y + config.deskSize
            minX = min(minX ?? position.x, position.x)
            minY = min(minY ?? position.y, position.y)
            maxX = max(maxX ?? deskMaxX, deskMaxX)
            maxY = max(maxY ?? deskMaxY, deskMaxY)
        }

        let outerPadding: CGFloat = 4
        let canvasPadding: CGFloat = 20
        let resolvedMinX = minX ?? 0
        let resolvedMinY = minY ?? 0
        let resolvedMaxX = maxX ?? 0
        let resolvedMaxY = maxY ?? 0
        let outerFrame = CGRect(
            x: resolvedMinX - outerPadding,
            y: resolvedMinY - outerPadding,
            width: resolvedMaxX - resolvedMinX + outerPadding * 2,
            height: resolvedMaxY - resolvedMinY + outerPadding * 2
        )
        let blockLabelPosition = CGPoint(
            x: outerFrame.midX + config.labelOffset.x,
            y: outerFrame.midY + config.labelOffset.y
        )
        let canvasSize = CGSize(
            width: max(resolvedMaxX + canvasPadding, blockLabelPosition.x + canvasPadding),
            height: max(resolvedMaxY + canvasPadding, blockLabelPosition.y + canvasPadding)
        )

        return BlockMapLayout(
            desks: desks,
            canvasSize: canvasSize,
            outerFrame: outerFrame,
            blockLabel: config.block,
            blockLabelPosition: blockLabelPosition
        )
    }
}
