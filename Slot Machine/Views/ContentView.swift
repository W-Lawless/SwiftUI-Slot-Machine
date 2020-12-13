//
//  ContentView.swift
//  Slot Machine
//
//  Created by W Lawless on 12/12/20.
//

import SwiftUI

struct ContentView: View {
    //MARK: - PROPERTIES
    
    let symbols = ["gfx-bell", "gfx-cherry", "gfx-coin", "gfx-grape", "gfx-seven", "gfx-strawberry"]
    let haptics = UINotificationFeedbackGenerator()
    
    @State private var highScore: Int = UserDefaults.standard.integer(forKey: "HighScore")
    @State private var coins: Int = 100
    @State private var ante: Int = 10
    @State private var reels: Array = [0, 1, 2]
    @State private var showInfoView: Bool = false
    @State private var ante10Active: Bool = true
    @State private var ante20Active: Bool = false
    @State private var _gameOver: Bool = false
    @State private var animateSymbol: Bool = false
    @State private var animateModel: Bool = false
    
    //MARK: - FUNCTIONS
    
    //SPIN REELS
    func spin() {
        reels = reels.map({ _ in
            Int.random(in: 0...symbols.count - 1)
        })
        
        playSound(sound: "spin", type: ".mp3")
//        reels[0] = Int.random(in: 0...symbols.count - 1)
//        reels[1] = Int.random(in: 0...symbols.count - 1)
//        reels[2] = Int.random(in: 0...symbols.count - 1)
    }
    
    
    //CHECK WIN CONDITION
    func checkWin() {
        if reels[0] == reels[1] && reels[1] == reels[2] && reels[0] == reels[2]{
            //PLAYER WINS
            playerWins()
            
            //NEW HIGH SCORE
            if coins > highScore {
                newHighScore()
            } else {
                playSound(sound: "win", type: ".mp3")
            }
        } else {
            //NO MATCHES
            playerLoses()
        }
    }
    
    func playerWins() {
        coins += ante * 10
    }
    
    func playerLoses() {
        coins -= ante
    }
    
    func newHighScore() {
        playSound(sound: "high-score", type: ".mp3")
        highScore = coins
        UserDefaults.standard.set(highScore, forKey: "HighScore")
    }
    
    func ante20 () {
        playSound(sound: "casino-chips", type: ".mp3")
        haptics.notificationOccurred(.success)
        ante20Active = true
        ante10Active = false
        ante = 20
    }
    
    func ante10() {
        haptics.notificationOccurred(.success)
        playSound(sound: "casino-chips", type: ".mp3")
        ante10Active = true
        ante20Active = false
        ante = 10
    }
    
    //GAME OVER
    func gameOver() {
        if coins <= 0 {
            //SHOW MODAL
            _gameOver = true
            playSound(sound: "game-over", type: ".mp3")
        }
    }
    
    //NEW GAME
    func reset() {
        _gameOver = false
        coins = 100
        ante10()
        playSound(sound: "chimeup", type: ".mp3")
    }
    
    var body: some View {
        
        ZStack {
            //MARK: -BACKGROUND
            LinearGradient(
                gradient: Gradient(
                    colors:
                        [Color("ColorPink"),
                         Color("ColorPurple")]
                ),
                startPoint: .top,
                endPoint: .bottom )
                .edgesIgnoringSafeArea(.all)
            
            //MARK: - INTERFACE
            
            VStack(alignment: .center, spacing: 5) {
                //MARK: - HEADER
                
                LogoView()
                Spacer()
                
                //MARK: - SCORE
                HStack {
                    
                    //MARK: -USER COINS
                    
                    HStack {
                        Text("Your\nCoins".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.trailing)
                        Text("\(coins)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                    } //: SCORE CAPSULE
                    .modifier(ScoreCapsule())
                    
                    Spacer()
                    
                    //MARK: - ANTE
                    
                    HStack {
                        Text("\(highScore)")
                            .scoreNumberStyle()
                            .modifier(ScoreNumberModifier())
                        Text("High\nScore".uppercased())
                            .scoreLabelStyle()
                            .multilineTextAlignment(.leading)
                    } //: SCORE CAPSULE
                    .modifier(ScoreCapsule())
                } //: HSTQ
                
                
                //MARK: - SLOT MACHINE
                
                VStack(alignment: .center, spacing: 0) {
                    
                    //MARK: - REEL 1
                    ZStack {
                        ReelView()
                        Image(symbols[reels[0]])
                            .resizable()
                            .modifier(ImgModifier())
                            .opacity(animateSymbol ? 1 : 0)
                            .offset(y: animateSymbol ? 0 : -50 )
                            .animation(.easeOut(duration: Double.random(in: 0.5...0.7)))
                            .onAppear(perform: {
                                self.animateSymbol.toggle()
                                playSound(sound: "riseup", type: ".mp3")
                                haptics.notificationOccurred(.success)
                            })
                    }
                    
                    HStack(alignment: .center, spacing: 0) {
                        
                        //MARK: - REEL 2
                        ZStack {
                            ReelView()
                            Image(symbols[reels[1]])
                                .resizable()
                                .modifier(ImgModifier())
                                .opacity(animateSymbol ? 1 : 0)
                                .offset(y: animateSymbol ? 0 : -50 )
                                .animation(.easeOut(duration: Double.random(in: 0.7...0.9)))
                                .onAppear(perform: {
                                    self.animateSymbol.toggle()
                                })
                        }
                        
                        Spacer()
                        
                        //MARK: - REEL 3
                        ZStack {
                            ReelView()
                            Image(symbols[reels[2]])
                                .resizable()
                                .modifier(ImgModifier())
                                .opacity(animateSymbol ? 1 : 0)
                                .offset(y: animateSymbol ? 0 : -50 )
                                .animation(.easeOut(duration: Double.random(in: 0.9...1.1)))
                                .onAppear(perform: {
                                    self.animateSymbol.toggle()
                                })
                        }
                    }
                    .frame(maxWidth: 500)
                    //MARK: - SPIN BTN
                    Button(action: {
                        withAnimation{
                            self.animateSymbol = false
                        }
                        
                        self.spin()
                        withAnimation {
                            self.animateSymbol = true
                        }
                        
                        self.checkWin()
                        self.gameOver()
                    }) {
                        Image("gfx-spin")
                            .renderingMode(.original)
                            .resizable()
                            .modifier(ImgModifier())
                    }
                    
                    
                } //: GAME UI
                .layoutPriority(2)
                
                
                //MARK: - FOOTER
                Spacer()
                
                HStack {
                    //MARK: - BET 20
                    HStack(alignment: .center, spacing: 10) {
                        Button(action: {
                            self.ante20()
                        }) {
                            Text("20")
                                .fontWeight(.heavy)
                                .foregroundColor(ante20Active ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberMod())
                        }
                        .modifier(BetBtnMod())
                        
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: ante20Active ? 0 : 20)
                            .opacity(ante20Active ? 1 : 0)
                            .modifier(ChipsMod())
                    } //: HSTQ

                    Spacer()
                    //MARK: - BET 10
                    HStack(alignment: .center, spacing: 10) {
                        Image("gfx-casino-chips")
                            .resizable()
                            .offset(x: ante20Active ? 0 : -20)
                            .opacity(ante10Active ? 1 : 0)
                            .modifier(ChipsMod())
                        
                        Button(action: {
                            self.ante10()
                        }) {
                            Text("10")
                                .fontWeight(.heavy)
                                .foregroundColor(ante10Active ? Color("ColorYellow") : Color.white)
                                .modifier(BetNumberMod())
                        }
                        .modifier(BetBtnMod())
                    } //: HSTQ
                    
                }
                
            } //: VSTQ
            .overlay(
                //MARK: - TOOL TIPS
                //RESET
                Button(action: {
                    reset()
                }) {
                    Image(systemName: "arrow.2.circlepath.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topLeading
            )
            .overlay(
                // INFO
                Button(action: {
                    self.showInfoView = true
                }) {
                    Image(systemName: "info.circle")
                }
                .modifier(ButtonModifier()),
                alignment: .topTrailing
            )
            .padding()
            .frame(maxWidth:720)
            .blur(radius: $_gameOver.wrappedValue ? 5 : 0, opaque: false)
            //MARK: - POPUP
            if $_gameOver.wrappedValue {
                ZStack {
                    Color("ColorTransparentBlack")
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 0) {
                        Text("Game Over")
                            .font(.system(.title, design: .rounded))
                            .fontWeight(.heavy)
                            .padding()
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .background(Color("ColorPink"))
                            .foregroundColor(Color.white)
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 16) {
                            Image("gfx-seven-reel")
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 72)
                            Text("Bad luck! You went bust!\nPlay Again?")
                                .font(.system(.body, design: .rounded))
                                .lineLimit(2)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.gray)
                                .layoutPriority(1)
                            Button(action: {
                                self.animateModel = false
                                self.reset()
                            }) {
                                Text("New Game".uppercased())
                                    .font(.system(.body, design: .rounded))
                                    .fontWeight(.semibold)
                                    .accentColor(Color("ColorPink"))
                                    .frame(minWidth: 128)
                                    .padding()
                                    .background(
                                        Capsule()
                                            .strokeBorder(lineWidth: 1.75)
                                            .foregroundColor(Color("ColorPink"))
                                    )
                            }
                        }
                        Spacer()
                    }
                    .frame(minWidth: 280, idealWidth: 280, maxWidth: 320, minHeight: 260, idealHeight: 280, maxHeight: 320, alignment: .center)
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: Color("ColorTransparentBlack"), radius: 6, x: 0, y: 8)
                    .opacity($animateModel.wrappedValue ? 1 : 0)
                    .offset(y: $animateModel.wrappedValue ? 0 : -100)
                    .animation(Animation.spring(response:0.6, dampingFraction: 1.0, blendDuration: 1.0))
                    .onAppear(perform: {
                        self.animateModel = true
                    })
                }
            }
            
            
        } //:ZSTQ
        .sheet(isPresented: $showInfoView) {
            InfoView()
        }
    } //: BODY
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
