import SwiftUI

// MARK: - Модель цвета клетки

enum BlockColor: String, CaseIterable, Equatable {
    case clear
    case red
    case green
    case blue
    case yellow
    case purple
    
    var uiColor: Color {
        switch self {
        case .clear:  return Color(.systemGray6)
        case .red:    return .red
        case .green:  return .green
        case .blue:   return .blue
        case .yellow: return .yellow
        case .purple: return .purple
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
        }
    }
}

// MARK: - Описание уровня

struct PuzzleLevel {
    let id: Int
    let target: [[BlockColor]]          // 3 строки × 5 столбцов
    let rowButtonColors: [BlockColor]   // 3 цвета для строк
    let columnButtonColors: [BlockColor]// 5 цветов для столбцов
}

// MARK: - Набор уровней
// Тут ты задаёшь "макет" – требуемые цвета для каждой ячейки

enum GameLevels {
    static let all: [PuzzleLevel] = [
        PuzzleLevel(
            id: 1,
            target: [
                [.red,   .red,   .green, .green, .blue],
                [.red,   .clear, .clear, .blue,  .blue],
                [.yellow,.yellow,.yellow,.yellow,.yellow]
            ],
            rowButtonColors: [.red, .blue, .yellow],
            columnButtonColors: [.red, .green, .blue, .yellow, .purple]
        ),
        PuzzleLevel(
            id: 2,
            target: [
                [.blue,  .blue,  .blue,  .blue,  .blue],
                [.green, .clear, .clear, .clear, .green],
                [.yellow,.yellow,.yellow,.yellow,.yellow]
            ],
            rowButtonColors: [.blue, .green, .yellow],
            columnButtonColors: [.red, .blue, .green, .yellow, .purple]
        ),
        PuzzleLevel(
            id: 3,
            target: [
                [.red,   .green, .blue,  .yellow,.purple],
                [.red,   .green, .blue,  .yellow,.purple],
                [.red,   .green, .blue,  .yellow,.purple]
            ],
            rowButtonColors: [.red, .green, .blue],
            columnButtonColors: [.red, .green, .blue, .yellow, .purple]
        ),
        PuzzleLevel(
            id: 4,
            target: [
                [.purple,.purple,.clear, .clear, .clear],
                [.clear, .purple,.purple,.purple,.clear],
                [.clear, .clear, .clear, .purple,.purple]
            ],
            rowButtonColors: [.purple, .yellow, .blue],
            columnButtonColors: [.purple, .red, .green, .blue, .yellow]
        ),
        PuzzleLevel(
            id: 5,
            target: [
                [.yellow,.red,   .yellow,.red,   .yellow],
                [.red,   .yellow,.red,   .yellow,.red],
                [.yellow,.red,   .yellow,.red,   .yellow]
            ],
            rowButtonColors: [.yellow, .red, .yellow],
            columnButtonColors: [.yellow,.red, .yellow,.red, .yellow]
        )
    ]
}

// MARK: - Основной экран игры

struct BeetleColorPuzzleView: View {
    
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
            // Немного простого фона
            LinearGradient(
                colors: [Color.blue.opacity(0.2), Color.purple.opacity(0.2)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                header
                
                HStack(alignment: .top, spacing: 24) {
                    playField
                    targetPreview
                }
                
                footer
            }
            .padding()
        }
        .onAppear {
            resetGridForCurrentLevel()
        }
        .alert("Уровень пройден!", isPresented: $isCompleted) {
            Button("Сыграть ещё раз") {
                resetGridForCurrentLevel()
            }
            if currentLevelIndex < GameLevels.all.count - 1 {
                Button("Следующий уровень") {
                    goToNextLevel()
                }
            }
            Button("OK", role: .cancel) { }
        } message: {
            Text("Ходов: \(moveCount)")
        }
    }
    
    // MARK: - Подвью
    
    private var header: some View {
        VStack(spacing: 4) {
            Text("Цветовой пазл жука")
                .font(.title2.bold())
            Text("Уровень \(currentLevelIndex + 1) из \(GameLevels.all.count)")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text("Ходы: \(moveCount)")
                .font(.subheadline.monospacedDigit())
        }
    }
    
    /// Игровое поле + кнопки строк/столбцов
    private var playField: some View {
        VStack(spacing: 8) {
            // Строки с кнопками слева
            ForEach(0..<BeetleColorPuzzleView.rows, id: \.self) { row in
                HStack(spacing: 8) {
                    rowButton(row)
                    
                    HStack(spacing: 4) {
                        ForEach(0..<BeetleColorPuzzleView.columns, id: \.self) { col in
                            cellView(row: row, column: col)
                        }
                    }
                }
            }
            
            // Кнопки столбцов снизу
            HStack(spacing: 8) {
                // Пустой отступ под кнопки строк, чтобы выровнять
                Spacer()
                    .frame(width: 40)
                
                ForEach(0..<BeetleColorPuzzleView.columns, id: \.self) { col in
                    columnButton(col)
                }
            }
            .padding(.top, 8)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.8))
        )
    }
    
    /// Превью целевого макета
    private var targetPreview: some View {
        VStack(spacing: 8) {
            Text("Образец")
                .font(.headline)
            
            VStack(spacing: 4) {
                ForEach(0..<BeetleColorPuzzleView.rows, id: \.self) { row in
                    HStack(spacing: 4) {
                        ForEach(0..<BeetleColorPuzzleView.columns, id: \.self) { col in
                            let color = currentLevel.target[row][col]
                            RoundedRectangle(cornerRadius: 4)
                                .fill(color.uiColor)
                                .frame(width: 22, height: 22)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color.black.opacity(0.15), lineWidth: 0.5)
                                )
                        }
                    }
                }
            }
            .padding(8)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white.opacity(0.9))
            )
        }
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
    
    private func rowButton(_ row: Int) -> some View {
        let color = currentLevel.rowButtonColors[row]
        return Button {
            applyRow(row, color: color)
        } label: {
            Circle()
                .fill(color.uiColor)
                .frame(width: 32, height: 32)
                .overlay(
                    Text("R\(row + 1)")
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                )
        }
        .buttonStyle(.plain)
    }
    
    private func columnButton(_ column: Int) -> some View {
        let color = currentLevel.columnButtonColors[column]
        return Button {
            applyColumn(column, color: color)
        } label: {
            Circle()
                .fill(color.uiColor)
                .frame(width: 32, height: 32)
                .overlay(
                    Text("C\(column + 1)")
                        .font(.caption2.bold())
                        .foregroundColor(.white)
                )
        }
        .buttonStyle(.plain)
    }
    
    private func cellView(row: Int, column: Int) -> some View {
        let color = grid[row][column]
        return RoundedRectangle(cornerRadius: 8)
            .fill(color.uiColor)
            .frame(width: 40, height: 40)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.black.opacity(0.2), lineWidth: 1)
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
