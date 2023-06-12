# Summary

### What's your app architecture? Why do you use this app architecture?

1. I use TCA in this project.(https://github.com/pointfreeco/swift-composable-architecture)
2. TCA 可以邏輯及UI切分，變成一塊一塊的模組，分成小塊的方式，有助於閱讀與撰寫測試。

### Did you use any 3rd-party libraries? If yes, why choose them? If not, why not use them?

I ues TCA in the project.

### Which part is the hardest? Why? How to approach this?

雖然用 M1 作 SwiftUI 開發很順暢，但是一段時間一直在用UIKit，反而回來寫 SwiftUI 時，又要重新習慣他的架構與語法，
並寫引入TCA的架構，造成時間上有點來不及。

目前還有以下未完成：
1. 以 TCA 架構包裝 Core Data 的 Action。
2. 撰寫測試。
3. due data預設24小時後。
4. 未讀取手機端Location資訊。
5. 「編輯」以及「刪除」功能還不完整。

### How long did it take? If you could start over, how would you speed up your implementation?

這次的專案大概花了10-15小時，如果重來，我可能會先不使用TCA，應該能提升一點速度。
