//
//  LabelManager.swift
//  MovieRating
//
//  Created by 혜리 on 2023/06/21.
//

import Foundation

struct Home {
    static let emptyState = "Search Movies"
    static let emptySearchState = "검색 결과가 없습니다."
    
    static let navigationBarTitle = "홈"
    static let searchBarPlaceHolder = "검색어를 입력하세요"
    
    static let movieSearchCount = "총 %02d개"
}


struct Storage {
    static let emptyState = "보관함 비어있음."
    
    static let navigationBarTitle = "보관함"
    
    static let unevaluationState = "평가 안 함 ⭐️ 0.0"
    static let evaluationState = "평가 함 ⭐️"
}


struct Detail {
    static let movieDetailInfo = "영화 상세정보 보기"
    static let movieRate = "영화 평가하기"
    static let storageDelete = "  보관함에서 삭제하기"
    
    static let storageDeleteAlertTitle = "Warning"
    static let storageDeleteAlertMessage = "정말 삭제하시겠습니까?\n삭제할 시 복구가 불가능합니다."
    static let storageDeleteAlertCancel = "취소"
    static let storageDeleteAlertDefault = "확인"
}


struct movieInfo {
    static let emptyInfo = "정보 없음"
}


struct Toast {
    static let saveMessage = "보관함에 저장 완료"
    static let deleteMessage = "삭제 완료"
}
