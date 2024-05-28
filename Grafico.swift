//
//  Grafico.swift
//  MusicalcORetorno
//
//  Created by Raquel Ribeiro Hatem de Farias on 21/05/24.
//

import Foundation
import SwiftUI
import Charts

struct Music: Identifiable {
    let id = UUID()
    let title: String
    let predefinedCount: Int
    var userCount: Int?
}

struct PieChartView: View {
    let music: Music
    
    var body: some View {
        let total = (music.userCount ?? 0) + music.predefinedCount
        Chart {
                if let userCount = music.userCount {
                    SectorMark(
                            angle: .value("Count", Double(userCount) / Double(total) * 360.0),
                            innerRadius: .ratio(0.5)
                        )
                        .foregroundStyle(.purple)
                        .annotation(position: .overlay) {
                            Text("Você")
                                .foregroundColor(.white)
                                .bold()
                        }
                    }
                    SectorMark(
                        angle: .value("Count", Double(music.predefinedCount) / Double(total) * 360.0),
                        innerRadius: .ratio(0.5)
                    )
                    .foregroundStyle(.red)
                    .annotation(position: .overlay) {
                        Text("Mundo")
                            .foregroundColor(.white)
                            .bold()
                    }
                }
                .chartLegend(.visible)
                .frame(height: 300)
            }
        }
