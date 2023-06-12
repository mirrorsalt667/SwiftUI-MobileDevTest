//
//  QuoteFetching.swift
//  SwiftUI-HikingbookMobileDevTest
//
//  Created by Stephen on 2023/6/12.
//

import ComposableArchitecture

// MARK: - API Reduce

let quoteUrlString = "https://api.quotable.io/random"
struct QuoteFetching: ReducerProtocol {
  
  let quoteResponse: () async throws -> QuoteType?
  
  struct State: Equatable {
    var quoteSentence: String? = "Getting Quote"
    var quoteAuthor: String?
  }
  
  enum Action: Equatable {
    case fetchQuoteFailed
    case getQuoteAction
    case getRandomQuote(QuoteType)
  }
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    switch action {
    case .fetchQuoteFailed:
      state.quoteSentence = nil
      state.quoteAuthor = nil
      return .none
    case .getQuoteAction:
      return .run { send in
        if let quote = try await self.quoteResponse() {
          print("取得APIs")
          await send(.getRandomQuote(quote))
        } else {
          print("取得失敗")
          await send(.fetchQuoteFailed)
        }
      }
    case let .getRandomQuote(quote):
      state.quoteSentence = quote.content
      state.quoteAuthor = quote.author
      return .none
    }
  }
}
