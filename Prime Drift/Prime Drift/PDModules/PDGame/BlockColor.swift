//
//  BlockColor.swift
//  Prime Drift
//
//


import SwiftUI

// MARK: - Модель цвета клетки

enum BlockColor: String, CaseIterable, Equatable {
    case clear
    case red
    case green
    case blue
    case yellow
    case purple
    case black
    case cyan
    case brown
    
    var uiColor: Color {
        switch self {
        case .clear:  return .appClear
        case .red:    return .appRed
        case .green:  return .appGreen
        case .blue:   return .appBlue
        case .yellow: return .appYellow
        case .purple: return .appPurple
        case .black: return .appBlack
        case .cyan: return .appCyan
        case .brown: return .appBrown
        }
    }
    
    var shortName: String {
        switch self {
        case .clear:  return "·"
        case .red:    return "R"
        case .green:  return "G"
        case .blue:   return "B"
        case .yellow: return "Y"
        case .purple: return "P"
        case .black: return "B"
        case .cyan: return "C"
        case .brown: return "B"
        }
    }
}

// MARK: - Описание уровня

struct PuzzleLevel {
    let id: Int
    let target: [[BlockColor]]
    let rowButtonColors: [BlockColor]
    let columnButtonColors: [BlockColor]// 5 цветов для столбцов
}

// MARK: - Набор уровней

enum GameLevels {
    static let all: [PuzzleLevel] = [
        PuzzleLevel(
            id: 1,
            target: [
                [.red,   .red,   .red, .red, .red],
                [.black,   .black, .black, .black,  .black],
                [.red,   .red,   .red, .red, .red]
            ],
            rowButtonColors: [.red, .black, .red],
            columnButtonColors: []
        ),
        PuzzleLevel(
            id: 2,
            target: [
                [.cyan,  .yellow,  .cyan,  .yellow, .brown],
                [.brown, .brown, .brown, .brown, .brown],
                [.cyan,  .yellow,  .cyan,  .yellow, .brown]
            ],
            rowButtonColors: [.yellow, .brown, .yellow],
            columnButtonColors: [.cyan, .yellow, .cyan, .yellow, .brown]
        ),
        PuzzleLevel(
            id: 3,
            target: [
                [.yellow, .yellow, .cyan, .blue, .black],
                [.purple, .purple, .purple, .blue, .purple],
                [.yellow, .yellow, .cyan, .blue, .black]
            ],
            rowButtonColors: [.yellow, .purple, .yellow],
            columnButtonColors: [.clear, .clear, .cyan, .blue, .black]
        ),
        PuzzleLevel(
            id: 4,
            target: [
                [.brown,.brown,.brown, .brown, .black],
                [.green, .green,.green,.brown,.black],
                [.brown, .brown, .brown, .brown,.black]
            ],
            rowButtonColors: [.brown, .brown, .brown],
            columnButtonColors: [.green, .green, .green, .clear, .black]
        ),
        PuzzleLevel(
            id: 5,
            target: [
                [.brown,  .brown,  .brown,  .brown, .brown],
                [.yellow, .yellow, .yellow, .black, .black],
                [.brown,  .brown,  .brown,  .brown,  .brown]
            ],
            rowButtonColors: [.brown, .clear, .brown],
            columnButtonColors: [.yellow, .yellow, .yellow, .black, .black]
        )
    ]
}

// MARK: - Основной экран игры

struct BeetleColorPuzzleView: View {
    @Environment(\.presentationMode) var presentationMode
    
    private static let rows = 3
    private static let columns = 5
    
    @State private var currentLevelIndex: Int = 0
    @State private var grid: [[BlockColor]] =
    Array(repeating: Array(repeating: .clear, count: BeetleColorPuzzleView.columns),
          count: BeetleColorPuzzleView.rows)
    @State private var moveCount: Int = 0
    @State private var isCompleted: Bool = false
    
    private var currentLevel: PuzzleLevel {
        GameLevels.all[currentLevelIndex]
    }
    
    var body: some View {
        ZStack {
            Image(.appBgPD)
                .resizable()
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                
                ZStack {
                    Image(.gameViewBgPD)
                        .resizable()
                        .scaledToFit()
                    
                    VStack(alignment: .center, spacing: 44) {
                        targetPreview
                        playField
                            .padding(.leading, 30)
                        
                    }
                }
                
            }
            .padding()
            
            VStack {
                HStack(alignment: .center) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Image(.backIconPD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
                    }
                    
                    Spacer()
                    
                    Text("Level \(currentLevelIndex + 1)")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Button {
                        resetGridForCurrentLevel()
                    } label: {
                        Image(.restartBtnPD)
                            .resizable()
                            .scaledToFit()
                            .frame(height: ZZDeviceManager.shared.deviceType == .pad ? 100:60)
                    }
                    
                }.padding(.horizontal).padding([.top])
                
                Spacer()
            }
            
            
            
            if isCompleted {
                ZStack {
                    Color.black.opacity(0.5).ignoresSafeArea()
                    
                    ZStack {
                        Image(.winBgPD)
                            .resizable()
                            .scaledToFit()
                        
                        VStack {
                            VStack(spacing: 16) {
                                Image(winImage)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 160)
                                
                                Text(winTitle)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundStyle(.white)
                                
                                Text(winDescription)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: 300)
                                    .multilineTextAlignment(.center)
                            }
                            
                            VStack {
                                if currentLevelIndex + 1 != 5 {
                                    Button {
                                        goToNextLevel()
                                    } label: {
                                        Image(.nextLevelBtnPD)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 50)
                                    }
                                }
                                
                                Button {
                                    presentationMode.wrappedValue.dismiss()
                                } label: {
                                    Image(.menuBtnPD)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 50)
                                }
                            }.padding(.top, 50)
                        }
                    }.frame(maxHeight: 660)
                }
            }
        }
        .onAppear {
            resetGridForCurrentLevel()
        }
    }
    
    // MARK: - Подвью
    
    private var winImage: String {
        switch currentLevelIndex + 1 {
        case 1:
            "level1ImagePD"
        case 2:
            "level2ImagePD"
        case 3:
            "level3ImagePD"
        case 4:
            "level4ImagePD"
        case 5:
            "level5ImagePD"
        default:
            "level1ImagePD"
        }
    }
    
    private var winTitle: String {
        switch currentLevelIndex + 1 {
        case 1:
            "Ladybug"
        case 2:
            "Firefly"
        case 3:
            "Jewel Beetle"
        case 4:
            "Stag Beetle"
        case 5:
            "Click Beetle"
        default:
            "Click Beetle"
        }
    }
    
    private var winDescription: String {
        switch currentLevelIndex + 1 {
        case 1:
            "Ladybugs are predators that feed on aphids, worms, and other small insects; only a few species are herbivorous. They are found almost everywhere on Earth, except for Antarctica and areas with permafrost."
        case 2:
            "Adult beetles do not usually feed, living off the nutrients stored during the larval stage. The larvae are predators, feeding on mollusks and hiding in their shells."
        case 3:
            "Habitat: Found on all continents except Antarctica, including North and South America, Asia, Africa, Europe, and Australia."
        case 4:
            "Stag Beetle — a beetle named for the enormous jaws of the males, which resemble deer antlers. These insects belong to the Lucanidae family and include more than 1,200 species found throughout the world."
        case 5:
            "Habitat: Found worldwide wherever there is vegetation and soil, except in the most extreme mountainous and arctic conditions. Lifestyle: Adult beetles are generally nocturnal, spending most of the day hidden under bark or near plants."
        default:
            "level1ImagePD"
        }
    }
    
    private var header: some View {
        VStack(spacing: 4) {
            Text("Цветовой пазл жука")
                .font(.title2.bold())
            Text("Уровень  из \(GameLevels.all.count)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Ходы: \(moveCount)")
                .font(.subheadline.monospacedDigit())
        }
    }
    
    /// Игровое поле + кнопки строк/столбцов
    private var playField: some View {
        ZStack {
            Image(.spiderPD)
                .resizable()
                .scaledToFit()
            
            VStack(spacing: 1) {
                // Строки с кнопками слева
                ForEach(0..<BeetleColorPuzzleView.rows, id: \.self) { row in
                    HStack(spacing: 26) {
                        rowButton(row)
                        
                        HStack(spacing: 0) {
                            ForEach(0..<BeetleColorPuzzleView.columns, id: \.self) { col in
                                cellView(row: row, column: col)
                            }
                        }
                    }
                }
                
                // Кнопки столбцов снизу
                HStack(spacing: 2) {
                    // Пустой отступ под кнопки строк, чтобы выровнять
                    Spacer()
                        .frame(width: 60)
                    
                    ForEach(0..<BeetleColorPuzzleView.columns, id: \.self) { col in
                        columnButton(col)
                    }
                }
                .padding(.top, 26)
            }.offset(x: -60, y: 30)
        }.frame(height: 200)
    }
    
    /// Превью целевого макета
    private var targetPreview: some View {
        
        VStack(spacing: 1) {
            ForEach(0..<BeetleColorPuzzleView.rows, id: \.self) { row in
                HStack(spacing: 1) {
                    ForEach(0..<BeetleColorPuzzleView.columns, id: \.self) { col in
                        let color = currentLevel.target[row][col]
                        RoundedRectangle(cornerRadius: 1)
                            .fill(color.uiColor)
                            .frame(width: 24, height: 24)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color.black.opacity(0.15), lineWidth: 0.5)
                            )
                    }
                }
            }
        }.background(.line)
            .padding(2)
            .background(
                Rectangle()
                    .fill(Color.line)
            )
        
    }
    
    private var footer: some View {
        HStack(spacing: 16) {
            Button("Сбросить уровень") {
                resetGridForCurrentLevel()
            }
            .buttonStyle(.borderedProminent)
            
            Spacer()
            
            if currentLevelIndex < GameLevels.all.count - 1 {
                Button("Пропустить уровень") {
                    goToNextLevel()
                }
                .buttonStyle(.bordered)
            }
        }
    }
    
    // MARK: - Элементы управления
    
    private var emptyButtonSlot: some View {
        Color.clear
            .frame(width: 32, height: 32)
    }
    
    private func rowButton(_ row: Int) -> some View {
        // Нет цвета для этого ряда → пустое место
        guard row < currentLevel.rowButtonColors.count else {
            return AnyView(emptyButtonSlot)
        }
        
        let color = currentLevel.rowButtonColors[row]
        
        // Если цвет .clear → пропуск (ничего не рисуем, только держим место)
        guard color != .clear else {
            return AnyView(emptyButtonSlot)
        }
        
        return AnyView(
            Button {
                applyRow(row, color: color)
            } label: {
                Circle()
                    .fill(color.uiColor)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 2)
                            .fill(.white.opacity(0.6))
                        
                    )
            }
        )
    }
    
    private func columnButton(_ column: Int) -> some View {
        // Нет цвета для этого столбца → пустое место
        guard column < currentLevel.columnButtonColors.count else {
            return AnyView(emptyButtonSlot)
        }
        
        let color = currentLevel.columnButtonColors[column]
        
        // Если цвет .clear → пропуск
        guard color != .clear else {
            return AnyView(emptyButtonSlot)
        }
        
        return AnyView(
            Button {
                applyColumn(column, color: color)
            } label: {
                Circle()
                    .fill(color.uiColor)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Circle()
                            .stroke(lineWidth: 2)
                            .fill(.white.opacity(0.6))
                        
                    )
            }
        )
    }
    
    
    private func cellView(row: Int, column: Int) -> some View {
        let color = grid[row][column]
        return RoundedRectangle(cornerRadius: 0)
            .fill(color.uiColor)
            .frame(width: 32, height: 32)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.line, lineWidth: 1)
            )
    }
    
    // MARK: - Логика игры
    
    private func applyRow(_ row: Int, color: BlockColor) {
        guard !isCompleted else { return }
        for col in 0..<BeetleColorPuzzleView.columns {
            grid[row][col] = color
        }
        moveCount += 1
        checkForWin()
    }
    
    private func applyColumn(_ column: Int, color: BlockColor) {
        guard !isCompleted else { return }
        for row in 0..<BeetleColorPuzzleView.rows {
            grid[row][column] = color
        }
        moveCount += 1
        checkForWin()
    }
    
    private func checkForWin() {
        let target = currentLevel.target
        for row in 0..<BeetleColorPuzzleView.rows {
            for col in 0..<BeetleColorPuzzleView.columns {
                if grid[row][col] != target[row][col] {
                    return
                }
            }
        }
        isCompleted = true
    }
    
    private func resetGridForCurrentLevel() {
        grid = Array(
            repeating: Array(repeating: .clear, count: BeetleColorPuzzleView.columns),
            count: BeetleColorPuzzleView.rows
        )
        moveCount = 0
        isCompleted = false
    }
    
    private func goToNextLevel() {
        if currentLevelIndex < GameLevels.all.count - 1 {
            currentLevelIndex += 1
            resetGridForCurrentLevel()
        }
    }
}

// MARK: - Превью

struct BeetleColorPuzzleView_Previews: PreviewProvider {
    static var previews: some View {
        BeetleColorPuzzleView()
    }
}
