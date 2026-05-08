import SwiftUI

// MARK: - Tokens

private extension Color {
    static let bgBase     = Color.black
    static let bgCard     = Color(red: 0.102, green: 0.102, blue: 0.102)   // #1a1a1a
    static let bgElevated = Color(red: 0.110, green: 0.110, blue: 0.118)   // #1c1c1e
    static let bgNeutralW = Color.white.opacity(0.10)
    static let bgNeutralD = Color.white.opacity(0.07)
    static let bgBtn      = Color(red: 0.192, green: 0.192, blue: 0.192)   // #313131
    static let primary    = Color(red: 0.965, green: 0.969, blue: 0.973)   // #f6f7f8
    static let secondary  = Color(red: 0.573, green: 0.600, blue: 0.635)   // #9299a2
    static let action     = Color(red: 0.341, green: 0.545, blue: 0.976)   // #5798fa
    static let action2    = Color(red: 0.259, green: 0.545, blue: 0.976)   // #428bf9
}

// MARK: - HomeView

struct HomeView: View {
    @State private var config = ParticleConfig()
    @State private var debugOpen = false

    private let screenHorizontalPadding: CGFloat = 16
    private let cardContentPadding: CGFloat = 20
    private let cardCornerRadius: CGFloat = 24
    private let sectionSpacing: CGFloat = 20

    private var heroBgColor: Color { config.heroGradientColor }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                ZStack(alignment: .top) {
                    Color.bgBase.ignoresSafeArea()

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            heroSection
                            cardStack
                        }
                    }
                }

                DebugPanel(config: $config, isOpen: $debugOpen)
                    .padding(.bottom, 8)
            }
            .navigationTitle("Моя зарплата")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbarBackground(.hidden, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "xmark")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                            .padding(7)
                            .background(Color.primary.opacity(0.85))
                            .clipShape(Circle())
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }

    // MARK: Hero section

    private var heroSection: some View {
        VStack(spacing: 0) {
            HeroView(config: config)
                .padding(.top, 6)
            VStack(spacing: 0) {
                Text("Ваш уровень")
                    .font(.system(size: 12))
                    .foregroundStyle(.secondary)
                    .padding(.top, 12)
                HStack(spacing: 12) {
                    Image(systemName: "laurel.leading")
                        .font(.system(size: 20))
                        .foregroundStyle(.white.opacity(0.8))
                    Text("Новичок")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(.white)
                        .tracking(0.38)
                    Image(systemName: "laurel.trailing")
                        .font(.system(size: 20))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(.top, 3)
                Text("Выполняйте задания, повышайте уровень\nи получайте больше привилегий")
                    .font(.system(size: 15))
                    .foregroundStyle(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .tracking(-0.24)
                    .padding(.top, 12)
                Button(action: {}) {
                    Text("К заданиям")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.action)
                        .tracking(-0.08)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 7)
                        .background(Color.bgNeutralW)
                        .clipShape(Capsule())
                }
                .padding(.top, 16)
            }
            .padding(.bottom, 28)
        }
        .frame(maxWidth: .infinity)
        .background(alignment: .top) {
            LinearGradient(
                stops: [
                    .init(color: heroBgColor, location: 0.0),
                    .init(color: heroBgColor, location: 0.45),
                    .init(color: heroBgColor.opacity(0.7), location: 0.7),
                    .init(color: heroBgColor.opacity(0.3), location: 0.85),
                    .init(color: Color.clear, location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .padding(.top, -200)
            .ignoresSafeArea(edges: .top)
        }
    }

    // MARK: Card stack

    private var cardStack: some View {
        VStack(spacing: sectionSpacing) {
            servicesPanel
            calendarCard
            spendingCard
            partnersCard
            balanceCard
            emergencyCard
            salaryCard
            bigNumberCard
            referralCard
        }
        .padding(.top, 8)
        .padding(.bottom, 40)
        .background(Color.bgBase)
    }

    // MARK: 1 — Services panel

    private var servicesPanel: some View {
        HStack(spacing: 2) {
            serviceItem(asset: "icon_documents", bg: Color(red: 0.486, green: 0.682, blue: 1.0).opacity(0.12), label: "Документы")
            serviceItem(asset: "icon_vacation",  bg: Color(red: 0.039, green: 0.761, blue: 0.686).opacity(0.12), label: "Отпуск")
            serviceItem(asset: "icon_briefcase", bg: Color(red: 0.639, green: 0.506, blue: 1.0).opacity(0.12), label: "Вакансии")
            serviceItem(asset: "icon_percent",   bg: Color(red: 0.345, green: 0.753, blue: 0.510).opacity(0.12), label: "Выгода")
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color.bgElevated)
        .clipShape(.rect(cornerRadius: cardCornerRadius))
        .shadow(color: .black.opacity(0.12), radius: 17, x: 0, y: 6)
        .padding(.horizontal, screenHorizontalPadding)
    }

    private func serviceItem(asset: String, bg: Color, label: String) -> some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16).fill(bg).frame(width: 56, height: 56)
                Image(asset)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 28, height: 28)
            }
            Text(label).font(.system(size: 12)).foregroundStyle(.primary).lineLimit(1)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: 2 — Calendar

    private var calendarCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Календарь выплат")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .tracking(0.38)
                .padding(.horizontal, cardContentPadding)
                .padding(.top, 16)
                .padding(.bottom, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    calendarItem(date: "17 марта",  amount: "140 000 ₽", checked: true)
                    calendarItem(date: "3 апреля",  amount: "140 000 ₽", checked: true)
                    calendarItem(date: "17 апреля", amount: "76 800 ₽",  checked: false)
                    calendarItem(date: "10 апреля", amount: "55 352 ₽",  checked: false)
                    calendarItem(date: "17 апреля", amount: "80 000 ₽",  checked: false)
                    calendarItem(date: "3 июня",    amount: "40 000 ₽",  checked: false)
                }
                .padding(.horizontal, cardContentPadding)
            }
            HStack(spacing: 12) {
                Image(systemName: "info.circle")
                    .font(.system(size: 20))
                    .foregroundColor(.secondary)
                Text("Зарплата через 12 дней")
                    .font(.system(size: 15))
                    .foregroundColor(.primary)
                    .tracking(-0.24)
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.bgNeutralD)
            .cornerRadius(12)
            .padding(.horizontal, cardContentPadding)
            .padding(.top, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgCard)
        .cornerRadius(cardCornerRadius)
        .shadow(color: .black.opacity(0.12), radius: 17, x: 0, y: 6)
        .padding(.horizontal, screenHorizontalPadding)
    }

    private func calendarItem(date: String, amount: String, checked: Bool) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            ZStack {
                Circle().strokeBorder(Color.white.opacity(0.3), lineWidth: 1.5).frame(width: 22, height: 22)
                if checked {
                    Circle().fill(Color.white).frame(width: 22, height: 22)
                    Image(systemName: "checkmark").font(.system(size: 11, weight: .bold)).foregroundColor(Color.bgCard)
                }
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(date).font(.system(size: 13)).foregroundColor(.primary.opacity(0.5)).tracking(-0.08)
                Text(amount).font(.system(size: 15, weight: .semibold)).foregroundColor(.primary).tracking(-0.24)
            }
        }
        .padding(12)
        .background(Color.bgNeutralD)
        .cornerRadius(20)
    }

    // MARK: 3 — Spending analysis

    private var spendingCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Проанализировали, куда вы тратите зарплату")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(0.38)
                Text("Если будете откладывать 20% от зарплаты ежемесячно, сможете накопить 235 000 ₽ за год")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .tracking(-0.24)
            }
            .padding(.horizontal, cardContentPadding)
            .padding(.top, 16)
            .padding(.bottom, 16)

            // Chart area — GeometryReader gives actual card width for x-scaling
            GeometryReader { geo in
                let W = geo.size.width
                let sf = W / 343  // scale x coords; y coords from Figma stay fixed

                ZStack {
                    // Gray axis: x=85, chart-relative y=53.5, w=6, h=60
                    Rectangle()
                        .fill(Color.secondary)
                        .frame(width: 6 * sf, height: 60)
                        .position(x: (85 + 3) * sf, y: 53.5 + 30)

                    // Bar 1 (62% Платежи): x=91, y=0..84.5
                    Image("chart_spending_bar")
                        .resizable()
                        .frame(width: 104.5 * sf, height: 84.5)
                        .position(x: (91 + 52.25) * sf, y: 42.25)

                    // Bar 2 (7% Остаток): x=91, y=68.5..93.5
                    Image("chart_spending_small")
                        .resizable()
                        .frame(width: 104 * sf, height: 25)
                        .position(x: (91 + 52) * sf, y: 68.5 + 12.5)

                    // Bar 3 (31% Переводы): x=91, y=93.5..146.5, flipY
                    Image("chart_spending_mid")
                        .resizable()
                        .scaleEffect(x: 1, y: -1)
                        .frame(width: 104 * sf, height: 53)
                        .position(x: (91 + 52) * sf, y: 93.5 + 26.5)

                    Text("Зарплата").font(.system(size: 11)).foregroundColor(.white)
                        .position(x: 46 * sf, y: 76.5 + 6)
                    Text("62%").font(.system(size: 20, weight: .bold, design: .rounded)).foregroundColor(.white).tracking(0.357)
                        .position(x: (205 + 22) * sf, y: 12)
                    Text("Платежи").font(.system(size: 10)).foregroundColor(.white)
                        .position(x: (257 + 17) * sf, y: 12)
                    Text("7%").font(.system(size: 20, weight: .bold, design: .rounded)).foregroundColor(.white).tracking(0.357)
                        .position(x: (205 + 15) * sf, y: 68.5 + 12)
                    Text("Остаток").font(.system(size: 10)).foregroundColor(.white)
                        .position(x: (256 + 17) * sf, y: 68.5 + 12)
                    Text("31%").font(.system(size: 20, weight: .bold, design: .rounded)).foregroundColor(.white).tracking(0.357)
                        .position(x: (205 + 20) * sf, y: 93.5 + 26.5)
                    Text("Переводы").font(.system(size: 10)).foregroundColor(.white)
                        .position(x: (256 + 18) * sf, y: 93.5 + 46.5)
                }
                .frame(width: W, height: 165)
            }
            .frame(height: 165)

            ZStack(alignment: .bottom) {
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.bgCard, location: 0),
                        .init(color: Color.bgCard.opacity(0), location: 1)
                    ]),
                    startPoint: .bottom, endPoint: .top
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Button(action: {}) {
                    Text("Как накопить больше")
                        .font(.system(size: 15)).foregroundColor(.action).tracking(-0.24)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.bgBtn)
                        .cornerRadius(12)
                }
                .padding(.horizontal, cardContentPadding)
                .padding(.bottom, 20)
            }
            .frame(height: 80)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgCard)
        .cornerRadius(cardCornerRadius)
        .clipped()
        .shadow(color: .black.opacity(0.12), radius: 17, x: 0, y: 6)
        .padding(.horizontal, screenHorizontalPadding)
    }

    // MARK: 4 — Partners

    private var partnersCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Предложения от партнеров")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .tracking(0.38)
                .padding(.horizontal, cardContentPadding)
                .padding(.top, 16)
                .padding(.bottom, 12)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    partnerImageCard("partner1")
                    partnerImageCard("partner2")
                    partnerTextCard("Goods",         "Кэшбэк 15%", Color(red: 0.729, green: 0.765, blue: 0.808), "avatar_goods")
                    partnerTextCard("Петруха Store", "Кэшбэк 20%", Color(red: 0.961, green: 0.776, blue: 0.718), "avatar_petrukha")
                    partnerTextCard("RU-MI.COM",     "Кэшбэк 10%", Color(red: 0.918, green: 0.667, blue: 0.561), "avatar_rumi")
                    partnerTextCard("Мегамаркет",    "Кэшбэк 15%", Color(red: 0.843, green: 0.761, blue: 0.961), "avatar_rumi")
                }
                .padding(.horizontal, cardContentPadding)
            }
            .frame(height: 160)
            Button(action: {}) {
                Text("Все предложения")
                    .font(.system(size: 15))
                    .foregroundColor(.action2)
                    .tracking(-0.24)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(Color.bgNeutralD)
                    .cornerRadius(12)
            }
            .padding(.horizontal, cardContentPadding)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgElevated)
        .cornerRadius(cardCornerRadius)
        .shadow(color: .black.opacity(0.12), radius: 17, x: 0, y: 6)
        .padding(.horizontal, screenHorizontalPadding)
    }

    private func partnerImageCard(_ name: String) -> some View {
        Image(name)
            .resizable()
            .scaledToFill()
            .frame(width: 140, height: 140)
            .clipped()
            .cornerRadius(16)
    }

    private func partnerTextCard(_ name: String, _ subtitle: String, _ bg: Color, _ avatar: String) -> some View {
        ZStack(alignment: .bottomLeading) {
            bg
            VStack(alignment: .leading, spacing: 4) {
                Text(name).font(.system(size: 15, weight: .semibold)).foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2)).tracking(-0.24).lineLimit(1)
                Text(subtitle).font(.system(size: 13)).foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2)).tracking(-0.08)
            }
            .padding(12)
            HStack {
                Spacer()
                Image(avatar).resizable().scaledToFill()
                    .frame(width: 56, height: 56).clipShape(Circle()).padding(12)
            }
        }
        .frame(width: 140, height: 140)
        .cornerRadius(12)
    }

    // MARK: 5 — Balance graph

    private var balanceCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Текущего баланса хватит\nна ~5 дней исходя из ваших трат")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(0.38)
                Text("Стоит оптимизировать расходы, чтобы дотянуть до зарплаты")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .tracking(-0.24)
            }
            .padding(.horizontal, cardContentPadding)
            .padding(.top, 16)
            .padding(.bottom, 12)
            balanceGraph.padding(.horizontal, cardContentPadding)
            Button(action: {}) {
                Text("Взять в займы")
                    .font(.system(size: 15))
                    .foregroundColor(.action)
                    .tracking(-0.24)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(Color.bgNeutralW)
                    .cornerRadius(12)
            }
            .padding(.horizontal, cardContentPadding)
            .padding(.top, 20)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgCard)
        .cornerRadius(cardCornerRadius)
        .shadow(color: .black.opacity(0.12), radius: 17, x: 0, y: 6)
        .padding(.horizontal, screenHorizontalPadding)
    }

    private var balanceGraph: some View {
        GeometryReader { geo in
            let W = geo.size.width
            let H: CGFloat = 97

            ZStack(alignment: .topLeading) {
                // Fill area under the line (gradient)
                LinearGradient(
                    colors: [Color.action.opacity(0.2), Color.clear],
                    startPoint: .top, endPoint: .bottom
                )
                .mask(
                    Image("chart_balance_line")
                        .resizable()
                        .scaleEffect(x: -1, y: 1)
                        .frame(width: W - 28, height: H)
                        .padding(.leading, 28)
                )
                .frame(width: W, height: H)

                // Actual SVG line: 255×99pt from Figma, mirrored horizontally
                // Figma: left=50 within 303pt area (card has 20pt padding, so 16+50=66 from card left)
                // We scale to full available width - left margin
                Image("chart_balance_line")
                    .resizable()
                    .scaleEffect(x: -1, y: 1)  // horizontal mirror = -scaleY*rotate180
                    .frame(width: W - 28, height: H)
                    .offset(x: 28, y: 0)

                // Dashed vertical line: Figma x=188 within 303 graph = 62% from left
                let lineX = 28 + (W - 28) * 0.62
                Path { p in
                    p.move(to: CGPoint(x: lineX, y: 0))
                    p.addLine(to: CGPoint(x: lineX, y: H))
                }
                .stroke(Color.secondary.opacity(0.4), style: StrokeStyle(lineWidth: 1, dash: [4, 3]))

                // Dot at Figma position (y=82/97 = 84.5% down)
                Circle().fill(Color.action).frame(width: 8, height: 8)
                    .position(x: lineX, y: H * 0.845)

                // Y-axis labels
                Text("100%").font(.system(size: 10, weight: .medium)).foregroundColor(.secondary)
                    .position(x: 14, y: 6)
                Text("50%").font(.system(size: 10, weight: .medium)).foregroundColor(.secondary)
                    .position(x: 14, y: H * 0.5)
                Text("0%").font(.system(size: 10, weight: .medium)).foregroundColor(.secondary)
                    .position(x: 12, y: H)

                // X-axis labels from Figma
                Text("День зарплаты").font(.system(size: 10, weight: .medium)).foregroundColor(.secondary)
                    .position(x: 28 + (W - 28) * 0.19, y: H + 12)
                Text("1 неделя").font(.system(size: 10, weight: .medium)).foregroundColor(.secondary)
                    .position(x: 28 + (W - 28) * 0.62, y: H + 12)
                Text("2 неделя").font(.system(size: 10, weight: .medium)).foregroundColor(.secondary)
                    .position(x: 28 + (W - 28) * 0.9, y: H + 12)
            }
            .frame(width: W, height: H + 24)
        }
        .frame(height: 128)
    }

    // MARK: 6 — Emergency

    private var emergencyCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("На случай, если очень нужно")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.primary)
                .tracking(0.38)
                .padding(.horizontal, cardContentPadding)
                .padding(.top, 16)
                .padding(.bottom, 12)
            VStack(spacing: 4) {
                emergencyRow("emergency_avatar1", "до 100 000 ₽", "Кредитная карта")
                emergencyRow("emergency_avatar2", "до 600 000 ₽", "На отпуск")
                emergencyRow("emergency_avatar2", "до 600 000 ₽", "На любые цели")
            }
            .padding(.bottom, 12)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgElevated)
        .cornerRadius(cardCornerRadius)
        .shadow(color: .black.opacity(0.12), radius: 17, x: 0, y: 6)
        .padding(.horizontal, screenHorizontalPadding)
    }

    private func emergencyRow(_ img: String, _ title: String, _ subtitle: String) -> some View {
        HStack(spacing: 0) {
            Image(img).resizable().scaledToFill()
                .frame(width: 56, height: 56).clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal, 16)
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.system(size: 17)).foregroundColor(.primary).tracking(-0.41)
                Text(subtitle).font(.system(size: 13)).foregroundColor(.secondary).tracking(-0.08)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white.opacity(0.22)).padding(.trailing, 16)
        }
        .frame(height: 56)
    }

    // MARK: 7 — Salary comparison

    private var salaryCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Вы получаете больше, чем 86% Front-end разработчиков")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .tracking(0.38)
                Text("На основе рынка и опроса пользователей")
                    .font(.system(size: 15))
                    .foregroundColor(.secondary)
                    .tracking(-0.24)
            }
            .padding(.horizontal, cardContentPadding)
            .padding(.top, 16)
            .padding(.bottom, 12)

            // Chart area — bell curve centered in card, labels at proportional SVG positions
            GeometryReader { geo in
                let W = geo.size.width
                let pad: CGFloat = 20
                let chartW = W - pad * 2
                let svgW: CGFloat = 301.7
                let x17  = pad + 17  * chartW / svgW + 10
                let x156 = pad + 156 * chartW / svgW + 13
                let x195 = pad + 195 * chartW / svgW + 13
                let x205 = pad + 205 * chartW / svgW
                let x209 = pad + 209 * chartW / svgW
                let x296 = min(pad + 296 * chartW / svgW - 12, W - 22)

                ZStack {
                    Image("chart_salary_dist")
                        .resizable()
                        .frame(width: chartW, height: 49.9)
                        .position(x: W / 2, y: 54 + 24.95)

                    Path { p in
                        p.move(to: CGPoint(x: x209, y: 30))
                        p.addLine(to: CGPoint(x: x209, y: 106))
                    }
                    .stroke(Color.action, style: StrokeStyle(lineWidth: 1.5, dash: [4, 3]))

                    Circle().fill(Color.action).frame(width: 8, height: 8)
                        .position(x: x205, y: 63)

                    Text("50K").font(.system(size: 10, weight: .medium)).foregroundColor(.secondary)
                        .position(x: x17, y: 116)
                    Text("200K").font(.system(size: 10, weight: .medium)).foregroundColor(.secondary)
                        .position(x: x156, y: 116)
                    Text("400K").font(.system(size: 10, weight: .medium)).foregroundColor(.action)
                        .position(x: x195, y: 106)
                    Text("1M +").font(.system(size: 10, weight: .medium)).foregroundColor(.secondary)
                        .position(x: x296, y: 116)
                }
                .frame(width: W, height: 130)
            }
            .frame(height: 130)

            Button(action: {}) {
                Text("Поделиться")
                    .font(.system(size: 15)).foregroundColor(.action).tracking(-0.24)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 13)
                    .background(Color.bgNeutralW)
                    .cornerRadius(12)
            }
            .padding(.horizontal, cardContentPadding)
            .padding(.top, 12)
            .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.bgCard)
        .cornerRadius(cardCornerRadius)
        .clipped()
        .shadow(color: .black.opacity(0.12), radius: 17, x: 0, y: 6)
        .padding(.horizontal, screenHorizontalPadding)
    }

    // MARK: 8 — Big number card

    private var bigNumberCard: some View {
        ZStack(alignment: .top) {
            // Background images (money + gradient) scale with card width
            GeometryReader { geo in
                let W = geo.size.width
                ZStack {
                    Image("money_stacks")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 255, height: 255)
                        .position(x: W / 2, y: 248)

                    LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color.bgCard, location: 0),
                            .init(color: Color.bgCard, location: 0.149),
                            .init(color: Color.bgCard.opacity(0), location: 1)
                        ]),
                        startPoint: .bottom, endPoint: .top
                    )
                    .frame(width: W, height: 190)
                    .position(x: W / 2, y: 225)
                }
            }

            // Text + button as a column
            VStack(spacing: 0) {
                VStack(spacing: 12) {
                    Text("6 832 035 ₽")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(.primary)
                        .tracking(0.357)
                    Text("Ваш доход за 2025 год")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .tracking(-0.24)
                }
                .padding(.top, 32)

                Spacer()

                Button(action: {}) {
                    Text("Как увеличить доход")
                        .font(.system(size: 15))
                        .foregroundColor(.action)
                        .tracking(-0.24)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.bgBtn)
                        .cornerRadius(12)
                }
                .padding(.horizontal, cardContentPadding)
                .padding(.bottom, 20)
            }

            // Tooltip icon top-right
            HStack {
                Spacer()
                ZStack {
                    Circle().fill(Color.bgNeutralD).frame(width: 22, height: 22)
                    Image(systemName: "questionmark").font(.system(size: 10)).foregroundColor(.secondary)
                }
                .padding(.top, 16)
                .padding(.trailing, cardContentPadding)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 320)
        .background(Color.bgCard)
        .cornerRadius(cardCornerRadius)
        .clipped()
        .shadow(color: .black.opacity(0.12), radius: 17, x: 0, y: 6)
        .padding(.horizontal, screenHorizontalPadding)
    }

    // MARK: 9 — Referral

    private var referralCard: some View {
        ZStack(alignment: .top) {
            // Glow ellipses
            Image("ellipse_glow1").resizable().frame(width: 262, height: 137).offset(x: -20, y: -34).blur(radius: 2)
            Image("ellipse_glow2").resizable().frame(width: 143, height: 137).offset(x: 50, y: -34).blur(radius: 2)
            VStack(spacing: 0) {
                referralAvatars.padding(.horizontal, cardContentPadding)
                VStack(spacing: 8) {
                    Text("Приведи коллегу в зарплатный клуб")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .tracking(0.38)
                        .multilineTextAlignment(.center)
                    Text("и получи +1 зарплату")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .tracking(-0.24)
                        .multilineTextAlignment(.center)
                }
                .padding(.horizontal, cardContentPadding)
                .padding(.top, 16)
                Button(action: {}) {
                    Text("Пригласить")
                        .font(.system(size: 15))
                        .foregroundColor(.action)
                        .tracking(-0.24)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.bgNeutralW)
                        .cornerRadius(12)
                }
                .padding(.horizontal, cardContentPadding)
                .padding(.top, 24)
                .padding(.bottom, 20)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.bgCard)
        .cornerRadius(cardCornerRadius)
        .clipped()
        .shadow(color: .black.opacity(0.12), radius: 17, x: 0, y: 6)
        .padding(.horizontal, screenHorizontalPadding)
    }

    private var referralAvatars: some View {
        let items: [(String, CGFloat, CGFloat, CGFloat)] = [
            ("referral_p1", 51, 49, 35),
            ("referral_p2", 38, 91, 98),
            ("referral_p2", 25, 220, 15),
            ("referral_p3", 56, 233, 61),
            ("referral_p4", 82, 132, 35),
        ]
        return ZStack {
            ForEach(0..<items.count, id: \.self) { i in
                let (name, size, lx, ty) = items[i]
                Image(name).resizable().scaledToFill()
                    .frame(width: size, height: size)
                    .clipShape(RoundedRectangle(cornerRadius: size * 0.6))
                    .overlay(RoundedRectangle(cornerRadius: size * 0.6).strokeBorder(Color.white.opacity(0.5), lineWidth: 1.3))
                    .position(x: lx + size/2, y: ty + size/2)
            }
        }
        .frame(width: 343, height: 136)
    }
}

#Preview { HomeView() }
