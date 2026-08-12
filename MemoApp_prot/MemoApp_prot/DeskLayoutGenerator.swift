import Foundation
import CoreGraphics

/// BlockLayoutConfig を受け取り、机配置を生成する
/// - 島サーの番号生成と座標計算をViewから分離するための生成器
/// - View側はここで作られたDeskDataを描画するだけにする
struct DeskLayoutGenerator {
    static func generate(from config: BlockLayoutConfig) -> [DeskData] {
        generateLayout(from: config).desks
    }

    static func generateLayout(from config: BlockLayoutConfig) -> BlockMapLayout {
        guard config.startNumber <= config.endNumber else {
            return BlockMapLayout(
                desks: [],
                canvasSize: .zero,
                outerFrame: .zero,
                blockLabel: config.block,
                blockLabelPosition: .zero
            )
        }

        let step = config.deskSize + config.spacing             // 同じ列/行の机1枚分の進み幅
        let foldedLineStep = config.deskSize + config.foldGap   // 折り返し後の列/行への進み幅
        var desks: [DeskData] = []
        desks.reserveCapacity(config.endNumber - config.startNumber + 1)

        var minX: CGFloat?
        var minY: CGFloat?
        var maxX: CGFloat?
        var maxY: CGFloat?

        for number in config.startNumber...config.endNumber {
            let grid = gridPosition(for: number, in: config)

            let position: CGPoint
            switch config.layoutDirection {
            case .horizontal:
                position = CGPoint(
                    x: config.origin.x + CGFloat(grid.primaryIndex) * step,
                    y: config.origin.y + CGFloat(grid.foldedLineIndex) * foldedLineStep
                )
            case .vertical:
                position = CGPoint(
                    x: config.origin.x + CGFloat(grid.foldedLineIndex) * foldedLineStep,
                    y: config.origin.y + CGFloat(grid.primaryIndex) * step
                )
            }

            let canonicalId = "\(config.hall)-\(config.block)-\(String(format: "%02d", number))"

            let desk = DeskData(
                id: canonicalId,
                canonicalId: canonicalId,
                hall: config.hall,
                block: config.block,
                number: String(format: "%02d", number),
                circleType: config.circleType,
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

        let outerPadding: CGFloat = 8
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
            x: outerFrame.midX,
            y: outerFrame.maxY + 18
        )
        let canvasSize = CGSize(
            width: resolvedMaxX + canvasPadding,
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

    /// 折り返し番号をもとに、主方向の何番目か / 何列目かを求める。
    /// horizontal: primaryIndex がX方向、foldedLineIndex がY方向
    /// vertical: primaryIndex がY方向、foldedLineIndex がX方向
    /// firstLinePosition/reversedを変えることで「右下が01」「左上が01」などの
    /// 会場ごとの番号向きを同じ生成処理で表現する。
    private static func gridPosition(
        for number: Int,
        in config: BlockLayoutConfig
    ) -> (primaryIndex: Int, foldedLineIndex: Int) {
        guard let foldAfterNumber = config.foldAfterNumber else {
            let index = number - config.startNumber
            let count = config.endNumber - config.startNumber + 1
            let primaryIndex = config.firstLineReversed
                ? max(0, count - 1 - index)
                : index
            return (primaryIndex, 0)
        }

        let firstLineCount = max(1, foldAfterNumber - config.startNumber + 1)
        let firstLineIndex = number - config.startNumber
        let firstLineGridIndex: Int
        let foldedLineGridIndex: Int

        switch config.firstLinePosition {
        case .leading:
            firstLineGridIndex = 0
            foldedLineGridIndex = 1
        case .trailing:
            firstLineGridIndex = 1
            foldedLineGridIndex = 0
        }

        guard number > foldAfterNumber else {
            let primaryIndex = config.firstLineReversed
                ? max(0, firstLineCount - 1 - firstLineIndex)
                : firstLineIndex
            return (primaryIndex, firstLineGridIndex)
        }

        let foldedIndex = number - foldAfterNumber - 1
        let foldedLineCount = max(1, config.endNumber - foldAfterNumber)
        let primaryIndex = config.foldedLineReversed
            ? max(0, foldedLineCount - 1 - foldedIndex)
            : foldedIndex

        return (primaryIndex, foldedLineGridIndex)
    }
}
