//
//  SFSymbolManager.swift
//  TofyKeys
//
//  Created by Mikel Lopez Salazar on 7/12/23.
//

import Foundation
import UIKit

class SFSymbolManager {
    static func getAllCategoryImages() -> [String: SymbolCategory] {
        
        let comunicacionSymbols: [String: SymbolCategory] = [
            "mic": .comunicacion,
            "mic.fill": .comunicacion,
            "mic.circle": .comunicacion,
            "mic.circle.fill": .comunicacion,
            "mic.square": .comunicacion,
            "mic.square.fill": .comunicacion,
            "mic.slash": .comunicacion,
            "mic.slash.fill": .comunicacion,
            "mic.slash.circle": .comunicacion,
            "mic.slash.circle.fill": .comunicacion,
            "mic.badge.plus": .comunicacion,
            "mic.fill.badge.plus": .comunicacion,
            "mic.badge.xmark": .comunicacion,
            "mic.fill.badge.xmark": .comunicacion,
            "mic.and.signal.meter": .comunicacion,
            "mic.and.signal.meter.fill": .comunicacion,
            "message": .comunicacion,
            "message.fill": .comunicacion,
            "message.circle": .comunicacion,
            "message.circle.fill": .comunicacion,
            "message.badge": .comunicacion,
            "message.badge.filled.fill": .comunicacion,
            "message.badge.circle": .comunicacion,
            "message.badge.circle.fill": .comunicacion,
            "message.badge.fill": .comunicacion,
            "message.and.waveform": .comunicacion,
            "message.and.waveform.fill": .comunicacion,
            "checkmark.message": .comunicacion,
            "checkmark.message.fill": .comunicacion,
            "arrow.up.message": .comunicacion,
            "arrow.up.message.fill": .comunicacion,
            "arrow.down.message": .comunicacion,
            "arrow.down.message.fill": .comunicacion,
            "plus.message": .comunicacion,
            "plus.message.fill": .comunicacion,
            "ellipsis.message": .comunicacion,
            "ellipsis.message.fill": .comunicacion,
            "bubble.right": .comunicacion,
            "bubble.right.fill": .comunicacion,
            "bubble.right.circle": .comunicacion,
            "bubble.right.circle.fill": .comunicacion,
            "bubble.left": .comunicacion,
            "bubble.left.fill": .comunicacion,
            "bubble.left.circle": .comunicacion,
            "bubble.left.circle.fill": .comunicacion,
            "exclamationmark.bubble": .comunicacion,
            "exclamationmark.bubble.fill": .comunicacion,
            "exclamationmark.bubble.circle": .comunicacion,
            "exclamationmark.bubble.circle.fill": .comunicacion,
            "quote.opening": .comunicacion,
            "quote.closing": .comunicacion,
            "quote.bubble": .comunicacion,
            "quote.bubble.fill": .comunicacion,
            "star.bubble": .comunicacion,
            "star.bubble.fill": .comunicacion,
            "character.bubble": .comunicacion,
            "character.bubble.fill": .comunicacion,
            "text.bubble": .comunicacion,
            "text.bubble.fill": .comunicacion,
            "captions.bubble": .comunicacion,
            "captions.bubble.fill": .comunicacion,
            "info.bubble": .comunicacion,
            "info.bubble.fill": .comunicacion,
            "questionmark.bubble": .comunicacion,
            "questionmark.bubble.fill": .comunicacion,
            "plus.bubble": .comunicacion,
            "plus.bubble.fill": .comunicacion,
            "checkmark.bubble": .comunicacion,
            "checkmark.bubble.fill": .comunicacion,
            "rectangle.3.group.bubble.left": .comunicacion,
            "rectangle.3.group.bubble.left.fill": .comunicacion,
            "ellipsis.bubble": .comunicacion,
            "ellipsis.bubble.fill": .comunicacion,
            "ellipsis.vertical.bubble": .comunicacion,
            "ellipsis.vertical.bubble.fill": .comunicacion,
            "phone.bubble.left": .comunicacion,
            "phone.bubble.left.fill": .comunicacion,
            "video.bubble.left": .comunicacion,
            "video.bubble.left.fill": .comunicacion,
            "speaker.wave.2.bubble.left": .comunicacion,
            "speaker.wave.2.bubble.left.fill": .comunicacion,
            "bubble.middle.bottom": .comunicacion,
            "bubble.middle.bottom.fill": .comunicacion,
            "bubble.middle.top": .comunicacion,
            "bubble.middle.top.fill": .comunicacion,
            "bubble.left.and.bubble.right": .comunicacion,
            "bubble.left.and.bubble.right.fill": .comunicacion,
            "bubble.left.and.exclamationmark.bubble.right": .comunicacion,
            "bubble.left.and.exclamationmark.bubble.right.fill": .comunicacion,
            "phone": .comunicacion,
            "phone.fill": .comunicacion,
            "phone.circle": .comunicacion,
            "phone.circle.fill": .comunicacion,
            "phone.badge.plus": .comunicacion,
            "phone.fill.badge.plus": .comunicacion,
            "phone.badge.checkmark": .comunicacion,
            "phone.fill.badge.checkmark": .comunicacion,
            "phone.connection": .comunicacion,
            "phone.connection.fill": .comunicacion,
            "phone.and.waveform": .comunicacion,
            "phone.and.waveform.fill": .comunicacion,
            "phone.arrow.up.right": .comunicacion,
            "phone.arrow.up.right.fill": .comunicacion,
            "phone.arrow.up.right.circle": .comunicacion,
            "phone.arrow.up.right.circle.fill": .comunicacion,
            "phone.arrow.down.left": .comunicacion,
            "phone.arrow.down.left.fill": .comunicacion,
            "phone.arrow.right": .comunicacion,
            "phone.arrow.right.fill": .comunicacion,
            "phone.down": .comunicacion,
            "phone.down.fill": .comunicacion,
            "phone.down.circle": .comunicacion,
            "phone.down.circle.fill": .comunicacion,
            "phone.down.waves.left.and.right": .comunicacion,
            "teletype": .comunicacion,
            "teletype.circle": .comunicacion,
            "teletype.circle.fill": .comunicacion,
            "teletype.answer": .comunicacion,
            "teletype.answer.circle": .comunicacion,
            "teletype.answer.circle.fill": .comunicacion,
            "video": .comunicacion,
            "video.fill": .comunicacion,
            "video.circle": .comunicacion,
            "video.circle.fill": .comunicacion,
            "video.square": .comunicacion,
            "video.square.fill": .comunicacion,
            "video.slash": .comunicacion,
            "video.slash.fill": .comunicacion,
            "video.badge.plus": .comunicacion,
            "video.fill.badge.plus": .comunicacion,
            "video.badge.checkmark": .comunicacion,
            "video.fill.badge.checkmark": .comunicacion,
            "video.badge.ellipsis": .comunicacion,
            "video.fill.badge.ellipsis": .comunicacion,
            "video.and.waveform": .comunicacion,
            "video.and.waveform.fill": .comunicacion,
            "arrow.up.right.video": .comunicacion,
            "arrow.up.right.video.fill": .comunicacion,
            "arrow.down.left.video": .comunicacion,
            "arrow.down.left.video.fill": .comunicacion,
            "questionmark.video": .comunicacion,
            "questionmark.video.fill": .comunicacion,
            "deskview": .comunicacion,
            "deskview.fill": .comunicacion,
            "envelope": .comunicacion,
            "envelope.fill": .comunicacion,
            "envelope.circle": .comunicacion,
            "envelope.circle.fill": .comunicacion,
            "envelope.arrow.triangle.branch": .comunicacion,
            "envelope.arrow.triangle.branch.fill": .comunicacion,
            "envelope.open": .comunicacion,
            "envelope.open.fill": .comunicacion,
            "envelope.open.badge.clock": .comunicacion,
            "envelope.badge": .comunicacion,
            "envelope.badge.fill": .comunicacion,
            "waveform": .comunicacion,
            "waveform.circle": .comunicacion,
            "waveform.circle.fill": .comunicacion,
            "waveform.slash": .comunicacion,
            "waveform.badge.plus": .comunicacion,
            "waveform.badge.minus": .comunicacion,
            "waveform.badge.exclamationmark": .comunicacion,
            "waveform.and.magnifyingglass": .comunicacion,
            "waveform.and.mic": .comunicacion,
            "recordingtape": .comunicacion,
            "recordingtape.circle": .comunicacion,
            "recordingtape.circle.fill": .comunicacion
        ]
        return comunicacionSymbols
//        return ["house.fill",
//                "lamp.table.fill",
//                "web.camera.fill",
//                "door.left.hand.closed",
//                "spigot.fill",
//                "shower.fill",
//                "bathtub.fill",
//                "pipe.and.drop.fill",
//                "videoprojector.fill",
//                "wifi.router.fill",
//                "party.popper.fill",
//                "balloon.fill",
//                "frying.pan.fill",
//                "popcorn.fill",
//                "bed.double.fill",
//                "sofa.fill",
//                "chair.lounge.fill",
//                "fireplace.fill",
//                "washer.fill",
//                "refrigerator.fill",
//                "sink.fill",
//                "toilet.fill",
//                "stairs"]
    }
}

enum SymbolCategory: CaseIterable {
    case comunicacion
    case meteorologia
    case objetos
    case dispositivos
    case fotos
    case videojuegos
    case conectividad
    case transporte
    case accesibilidad
    case privacidad
    case personas
    case casa
    case fitness
    case naturaleza
    case edicion
    case texto
    case multimedia
    case teclado
    case comercio
    case tiempo
    case salud
    case figuras
    case flechas
    case indices
    case matematicas
    
    func getTitle() -> String {
        switch self {
        case .comunicacion: return "Comunicacion"
        case .meteorologia: return "Meteorología"
        case .objetos: return "Objetos y herramientas"
        case .dispositivos: return "Dispositivos"
        case .fotos: return "Cámara y fotos"
        case .videojuegos: return "Videojuegos"
        case .conectividad: return "Conectividad"
        case .transporte: return "Transporte"
        case .accesibilidad: return "Accesibilidad"
        case .privacidad: return "Privacidad"
        case .personas: return "Personas"
        case .casa: return "Casa"
        case .fitness: return "Fitness"
        case .naturaleza: return "Naturaleza"
        case .edicion: return "Edicion"
        case .texto: return "Formato de texto"
        case .multimedia: return "Multimedia"
        case .teclado: return "Teclado"
        case .comercio: return "Comercio"
        case .tiempo: return "Tiempo"
        case .salud: return "Salud"
        case .figuras: return "Figuras"
        case .flechas: return "Flechas"
        case .indices: return "Índices"
        case .matematicas: return "Matemáticas"
        }
    }
}
