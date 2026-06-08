import Foundation
import CoreGraphics

/// WallLayoutConfig を受け取り、壁サー用の一列机配置を生成する
struct WallLayoutGenerator {
    static func generateLayout(from config: WallLayoutConfig) -> BlockMapLayout {
        let deskCount = config.numberGroups.reduce(0) { $0 + $1.count }
        guard deskCount > 0 else {
            return BlockMapLayout(
                desks: [],
                canvasSize: .zero,
                outerFrame: .zero,
                blockLabel: "",
                blockLabelPosition: .zero
            )
        }

        let step = config.deskSize + config.spacing
        let direction: CGFloat = config.isReversed ? -1 : 1
        var desks: [DeskData] = []
        desks.reserveCapacity(deskCount)
        var cursor: CGFloat = 0
        var blockLabelPosition: CGPoint?

        var minX: CGFloat?
        var minY: CGFloat?
        var maxX: CGFloat?
        var maxY: CGFloat?

        for (groupIndex, numbers) in config.numberGroups.enumerated() {
            var lastPosition: CGPoint?

            for number in numbers {
                let position = position(
                    from: config.origin,
                    distance: cursor * direction,
                    direction: config.layoutDirection
                )

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
                lastPosition = position
                cursor += step

                let deskMaxX = position.x + config.deskSize
                let deskMaxY = position.y + config.deskSize
                minX = min(minX ?? position.x, position.x)
                minY = min(minY ?? position.y, position.y)
                maxX = max(maxX ?? deskMaxX, deskMaxX)
                maxY = max(maxY ?? deskMaxY, deskMaxY)
            }

            guard groupIndex < config.numberGroups.count - 1 else {
                continue
            }

            if config.labelAfterGroupIndex == groupIndex,
               let lastPosition {
                let nextPosition = position(
                    from: config.origin,
                    distance: (cursor + config.groupSpacing) * direction,
                    direction: config.layoutDirection
                )
                blockLabelPosition = gapCenter(
                    lastPosition: lastPosition,
                    nextPosition: nextPosition,
                    deskSize: config.deskSize,
                    layoutDirection: config.layoutDirection,
                    isReversed: config.isReversed
                )
            }

            cursor += config.groupSpacing
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
        let resolvedLabelPosition = blockLabelPosition ?? .zero
        let canvasSize = CGSize(
            width: max(resolvedMaxX + canvasPadding, resolvedLabelPosition.x + canvasPadding),
            height: max(resolvedMaxY + canvasPadding, resolvedLabelPosition.y + canvasPadding)
        )

        return BlockMapLayout(
            desks: desks,
            canvasSize: canvasSize,
            outerFrame: outerFrame,
            blockLabel: blockLabelPosition == nil ? "" : config.block,
            blockLabelPosition: resolvedLabelPosition
        )
    }

    private static func position(
        from origin: CGPoint,
        distance: CGFloat,
        direction: LayoutDirection
    ) -> CGPoint {
        switch direction {
        case .horizontal:
            return CGPoint(x: origin.x + distance, y: origin.y)
        case .vertical:
            return CGPoint(x: origin.x, y: origin.y + distance)
        }
    }

    private static func gapCenter(
        lastPosition: CGPoint,
        nextPosition: CGPoint,
        deskSize: CGFloat,
        layoutDirection: LayoutDirection,
        isReversed: Bool
    ) -> CGPoint {
        switch layoutDirection {
        case .horizontal:
            let leadingEdge = isReversed ? nextPosition.x + deskSize : lastPosition.x + deskSize
            let trailingEdge = isReversed ? lastPosition.x : nextPosition.x
            return CGPoint(
                x: (leadingEdge + trailingEdge) / 2,
                y: lastPosition.y + deskSize / 2
            )

        case .vertical:
            let leadingEdge = isReversed ? nextPosition.y + deskSize : lastPosition.y + deskSize
            let trailingEdge = isReversed ? lastPosition.y : nextPosition.y
            return CGPoint(
                x: lastPosition.x + deskSize / 2,
                y: (leadingEdge + trailingEdge) / 2
            )
        }
    }
}
