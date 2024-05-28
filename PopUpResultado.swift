//
//  PopUpResultado.swift
//  MusicalcORetorno
//
//  Created by Raquel Ribeiro Hatem de Farias on 21/05/24.
//

import SwiftUI


struct PopUpResultado: View {
    @Binding var isShowing: Bool
    let music: Music
    let resetFunction: () -> Void
    @State private var showInfoAlert: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text("\(music.title)")
                    .font(.header3)
                    .padding(.leading)

                Button(action: {
                    showInfoAlert = true
                }) {
                    Image(systemName: "questionmark.circle")
                        .font(.title3)
                }
                .padding(.trailing)
                .alert(isPresented: $showInfoAlert) {
                    Alert(
                        title: Text("Informação"),
                        message: Text("A comparação foi realizada entre a média de vezes que a música foi ouvida por pessoa no mundo e o valor inserido por você."),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }

            Spacer()

            PieChartView(music: music)
                .frame(height: 50)
                .padding()

            Spacer()

            Button("Fechar") {
                isShowing = false
                resetFunction()
            }
            .frame(width: 300)
            .frame(height: 50)
            .background(.black)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .font(.body)
            .padding(.bottom)
        }
        .frame(width: 400, height: 500)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 20)
        .opacity(isShowing ? 10 : 1)
    }
}
