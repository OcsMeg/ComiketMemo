import CoreGraphics

/// 通路設定をもとに机をずらし、机が配置されない領域を作る
struct AisleLayoutGenerator {
    static func generate(
        blockLayouts: [BlockMapLayout],
        aisleConfigs: [AisleLayoutConfig]
    ) -> ComposedMapLayout {
        let aisles = aisleConfigs.map { makeAisle(from: $0, allConfigs: aisleConfigs) }
        let islandLabelY = zip(aisleConfigs, aisles)
            .first { config, _ in
                config.direction == .horizontal && config.showsIslandLabels
            }?
            .1
            .frame
            .midY
        let layouts = blockLayouts.map {
            transform(
                layout: $0,
                with: aisleConfigs,
                islandLabelY: islandLabelY
            )
        }
        let canvasSize = calculateCanvasSize(layouts: layouts, aisles: aisles)

        return ComposedMapLayout(
            blockLayouts: layouts,
            aisles: aisles,
            canvasSize: canvasSize
        )
    }

    private static func transform(
        layout: BlockMapLayout,
        with configs: [AisleLayoutConfig],
        islandLabelY: CGFloat?
    ) -> BlockMapLayout {
        let desks = layout.desks.map { desk in
            let position = transform(point: desk.position, with: configs)

            return DeskData(
                id: desk.id,
                canonicalId: desk.canonicalId,
                hall: desk.hall,
                block: desk.block,
                number: desk.number,
                circleType: desk.circleType,
                position: position,
                size: desk.size,
                rotationDegrees: desk.rotationDegrees,
                splitDirection: desk.splitDirection,
                availableSpaces: desk.availableSpaces
            )
        }

        let outerFrame = transform(rect: layout.outerFrame, with: configs)
        var blockLabelPosition = transform(
            point: layout.blockLabelPosition,
            with: configs
        )
        if isIslandLayout(layout), let islandLabelY {
            blockLabelPosition.y = islandLabelY
        }
        let canvasSize = CGSize(
            width: max(layout.canvasSize.width, outerFrame.maxX + 20),
            height: max(layout.canvasSize.height, blockLabelPosition.y + 20)
        )

        return BlockMapLayout(
            desks: desks,
            canvasSize: canvasSize,
            outerFrame: outerFrame,
            blockLabel: layout.blockLabel,
            blockLabelPosition: blockLabelPosition
        )
    }

    private static func isIslandLayout(_ layout: BlockMapLayout) -> Bool {
        guard let circleType = layout.desks.first?.circleType else {
            return false
        }

        switch circleType {
        case .island:
            return true
        case .wall:
            return false
        }
    }

    private static func transform(
        point: CGPoint,
        with configs: [AisleLayoutConfig]
    ) -> CGPoint {
        var result = point

        for config in configs {
            switch config.direction {
            case .horizontal:
                if point.y >= config.position {
                    result.y += config.width
                }
            case .vertical:
                if point.x >= config.position {
                    result.x += config.width
                }
            }
        }

        return result
    }

    private static func transform(
        rect: CGRect,
        with configs: [AisleLayoutConfig]
    ) -> CGRect {
        let transformedOrigin = transform(point: rect.origin, with: configs)
        let transformedMax = transform(
            point: CGPoint(x: rect.maxX, y: rect.maxY),
            with: configs
        )

        return CGRect(
            x: transformedOrigin.x,
            y: transformedOrigin.y,
            width: transformedMax.x - transformedOrigin.x,
            height: transformedMax.y - transformedOrigin.y
        )
    }

    private static func makeAisle(
        from config: AisleLayoutConfig,
        allConfigs: [AisleLayoutConfig]
    ) -> AisleData {
        let precedingConfigs = allConfigs.filter { other in
            guard other.id != config.id else { return false }

            switch (config.direction, other.direction) {
            case (.horizontal, .horizontal), (.vertical, .vertical):
                return other.position < config.position
            default:
                return true
            }
        }

        let origin: CGPoint
        let size: CGSize

        switch config.direction {
        case .horizontal:
            let transformedStart = transform(
                point: CGPoint(x: config.spanStart, y: config.position),
                with: precedingConfigs
            )
            origin = transformedStart
            size = CGSize(width: config.spanLength, height: config.width)

        case .vertical:
            let transformedStart = transform(
                point: CGPoint(x: config.position, y: config.spanStart),
                with: precedingConfigs
            )
            origin = transformedStart
            size = CGSize(width: config.width, height: config.spanLength)
        }

        return AisleData(
            id: config.id,
            frame: CGRect(origin: origin, size: size)
        )
    }

    private static func calculateCanvasSize(
        layouts: [BlockMapLayout],
        aisles: [AisleData]
    ) -> CGSize {
        let layoutWidth = layouts.map(\.canvasSize.width).max() ?? 0
        let layoutHeight = layouts.map(\.canvasSize.height).max() ?? 0
        let aisleWidth = aisles.map(\.frame.maxX).max() ?? 0
        let aisleHeight = aisles.map(\.frame.maxY).max() ?? 0
        let padding: CGFloat = 20

        return CGSize(
            width: max(layoutWidth, aisleWidth) + padding,
            height: max(layoutHeight, aisleHeight) + padding
        )
    }
}
