//
//  Errors.swift
//  Test
//
//  Created by Никита Кожухов on 02.03.2025.
//

import Foundation

enum NetworkErrors: LocalizedError {
	
	case invalidURL
	case noData
	case decodingFailed
	
	var errorDescription: String? {
		switch self {
		case .invalidURL:
			return "Неправильный URL"
		case .noData:
			return "Нет данных"
		case .decodingFailed:
			return "Ошибка декодирования"
		}
	}
	
}
