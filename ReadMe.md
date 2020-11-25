Добавить зависимость pod ‘RushSDK’, :git => «https://github.com/AgentChe/rushSDK.git»
Добавить Bridging-Header.h для глобального импорта сдк
В AppDelegate создать объект SDKProvider и вызвать метод initialize(settings:) ВАЖНО: метод initialize вызывать ДО триггеров делегата в провайдере
В приложении обязательно должен быть splash screen. Его view используется в sdk для регистрации (запуск webview). Пример см в Horo
Добавить в .plist ключи для fb и бранча
FirebaseApp.configure() вызывается в фиче-приложении
Все зависимости SDK берутся только из SDKStorage (даже внутри самого SDK)
