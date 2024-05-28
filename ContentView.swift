//
//  ContentView.swift
//  MusicalcORetorno
//
//  Created by Raquel Ribeiro Hatem de Farias on 20/05/24.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State var failedInput = false
    @State var selectedButton: String? = nil
    @State var userResponses: [String: Int] = [:]
    @State var showAlert: Bool = false
    @State private var isShowingChart: Bool = false
    @State private var showPopUP = false
    @State private var selectedMusic: Music? = nil
    @State private var audioPlayer: AVAudioPlayer?

   

    let songs: [String: (title: String, color: Color)] = [
        "green": ("Sua Cara", .verde),
        "blue": ("Dancing Queen", .azul),
        "purple": ("Single Ladies", .roxo),
        "pink": ("Anunciação", .rosa),
        "yellow": ("Someone Like You", .amarelo),
        "orange": ("Highway to Hell", .laranja),
        "red": ("Summertime Sadness", .vermelho)
    ]

    let predefinedValues = [
        // Plays na musica no spotfy/numero de seguidoers da artista.
        "Sua Cara": 206051262/31191465,
        "Dancing Queen": 1279752803/32707590,
        "Single Ladies": 657208186/65180591,
        "Anunciação": 116597449/3153136,
        "Someone Like You": 1904662381/50386714,
        "Highway to Hell": 1557949370/37470391,
        "Summertime Sadness": 1409114049/55194512
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    VStack(alignment: .leading, spacing: 20.0) {
                        Spacer()
                        Text("Você escuta muito música?")
                            .font(.header5)
                            .padding(.leading,10)
                    // Divider()
                    Spacer()
                        Text("Escolha uma das músicas e responda a pergunta abaixo.")
                            .font(.header6)
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                        VStack(alignment: .center, spacing: -10.0) {
                            HStack(spacing: -10) {
                                ForEach(["green", "blue", "purple", "pink"], id: \.self) { color in
                                    if let song = songs[color] {
                                        createButton(for: color, song: song)
                                    }
                                }
                            }
                            HStack(spacing: 0) {
                                ForEach(["yellow", "orange", "red"], id: \.self) { color in
                                    if let song = songs[color] {
                                        createButton(for: color, song: song)
                                    }
                                }
                            }
                        }
                        Spacer()

                            Text("Quantas vezes você acha que já escutou a música escolhida na sua vida, em média?")
                                .font(.header6)
                                .padding(.leading, 10)
                                .padding(.trailing, 10)

                        TextField(
                            "Insira sua resposta",
                            value: Binding(
                                get: {
                                    if let selectedButton = selectedButton {
                                        return userResponses[selectedButton] ?? 0
                                    } else {
                                        return 0
                                    }
                                },
                                set: { newValue in
                                    if let selectedButton = selectedButton {
                                        userResponses[selectedButton] = newValue
                                    } else {
                                        showAlert = true
                                    }
                                }
                            ),
                            format: .number
                        )
                        .padding()
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.numberPad)
                        Spacer()

                        Button("Calcular", action: resultado)
                            .frame(width: 300)
                            .frame(height: 50)
                            .background(.black)
                            .foregroundColor(.white)
                            .padding(.leading, 50)
                            .padding(.trailing, 50)
                            .padding(.bottom,10)
                            
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .font(.body)
                    }
                    .padding()
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("Nenhuma música selecionada"),
                            message: Text("Por favor, selecione uma música antes de inserir sua resposta."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    .navigationTitle("MusiCalc")
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(.black, for: .navigationBar)

                    if let selectedMusic = selectedMusic {
                        PopUpResultado(isShowing: $showPopUP, music: selectedMusic, resetFunction: reset)
                            .opacity(showPopUP ? 1 : 0)
                            .animation(.easeInOut, value: showPopUP)
                            .onTapGesture {
                             showPopUP = false
                              reset()
                          }
                    }
                }
            }
        }
    }

    func createButton(for id: String, song: (title: String, color: Color)) -> some View {
        Button(
            action: {
                if self.selectedButton == id {
                    self.selectedButton = nil
                    stopMusic()
                } else {
                    stopMusic()
                    self.selectedButton = id
                    playMusic(sound: song.title, type: "m4a", volume: 1.0, numberOfLoops: -1)
                }
            },
            label: {
                Image(systemName: self.selectedButton == id ? "play.circle" : "play.circle.fill")
                    .resizable()
                    .foregroundColor(song.color)
                    .frame(width: 70, height: 70)
            })
        .padding()
    }

    func resultado() {
        // stopMusic()
        guard let selectedButton = selectedButton, let song = songs[selectedButton], let predefinedCount = predefinedValues[song.title] else {
            showAlert = true
            return
        }

        let userCount = userResponses[selectedButton] ?? 0
        selectedMusic = Music(title: song.title, predefinedCount: predefinedCount, userCount: userCount)
        showPopUP = true
    }

    func playMusic(sound: String, type: String, volume: Float, numberOfLoops: Int) {
        if let path = Bundle.main.path(forResource: sound, ofType: type) {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.volume = volume
                audioPlayer?.numberOfLoops = numberOfLoops
                audioPlayer?.play()
            } catch {
                print("ERROR: Could not find and play the sound file!")
            }
        }
    }

    func stopMusic() {
        audioPlayer?.stop()
        audioPlayer = nil
    }
    
    func reset() {
            selectedButton = nil
            userResponses = [:]
            selectedMusic = nil
            stopMusic()
        }
    
}


#Preview {
    ContentView()
}
