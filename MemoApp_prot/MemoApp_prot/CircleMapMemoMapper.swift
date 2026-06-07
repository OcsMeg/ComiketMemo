import Foundation

/// CircleInfo の場所情報をマップ描画用の DeskMemoState に変換する
struct CircleMapMemoMapper {
    static func makeMemoStates(
        from circles: [CircleInfo],
        layouts: [BlockMapLayout]
    ) -> [DeskMemoState] {
        circles.compactMap { circle in
            guard let parsedPlace = parsePlace(circle.place),
                  let matchedDesk = findDesk(
                    hall: circle.direction,
                    block: parsedPlace.block,
                    number: parsedPlace.number,
                    in: layouts
                  ) else {
                return nil
            }

            return DeskMemoState(
                deskId: matchedDesk.canonicalId,
                space: parsedPlace.space,
                isPurchased: false
            )
        }
    }

    private static func findDesk(
        hall: String,
        block: String,
        number: String,
        in layouts: [BlockMapLayout]
    ) -> DeskData? {
        for layout in layouts {
            for desk in layout.desks {
                guard isSameHall(circleHall: hall, deskHall: desk.hall),
                      desk.block == block,
                      desk.number == number else {
                    continue
                }

                return desk
            }
        }

        return nil
    }

    private static func isSameHall(circleHall: String, deskHall: String) -> Bool {
        let normalizedCircleHall = circleHall.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !normalizedCircleHall.isEmpty else { return true }
        return deskHall == normalizedCircleHall || deskHall.hasPrefix(normalizedCircleHall)
    }

    private static func parsePlace(_ place: String) -> ParsedPlace? {
        let trimmedPlace = place.trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedPlace = trimmedPlace.lowercased()
        let pattern = #"^(.+?)-?(\d+)(ab|a|b)$"#

        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(
                in: normalizedPlace,
                range: NSRange(normalizedPlace.startIndex..., in: normalizedPlace)
              ),
              let blockRange = Range(match.range(at: 1), in: normalizedPlace),
              let numberRange = Range(match.range(at: 2), in: normalizedPlace),
              let spaceRange = Range(match.range(at: 3), in: normalizedPlace) else {
            return nil
        }

        let block = String(normalizedPlace[blockRange]).uppercased()
        let numberValue = Int(normalizedPlace[numberRange]) ?? 0
        let number = String(format: "%02d", numberValue)
        let spaceText = String(normalizedPlace[spaceRange])

        guard let space = SpaceType(rawValue: spaceText) else {
            return nil
        }

        return ParsedPlace(block: block, number: number, space: space)
    }
}

private struct ParsedPlace {
    let block: String
    let number: String
    let space: SpaceType
}
