1. Settings 
SDKProvider - точка входа в SDK
SDKSettings - объект, через который пользователь SDK задает настройки. Передается исключительно в метод initialize провайдера. 
SDKStorage - хранилище настроек и менеджеров. Любая зависимость SDK берется из хранилища. 

2. Network
Открыт для использования в фиче-приложении для выполнения сетевых запросов. 
APIRequestBody - протокол, описывает запрос 
NetworkError - ошибка сетевого слоя 
RestAPITransport - объект, выполняющий сетевой запрос

3. IAP
IAPProduct - объект, представляющий продукт in-app purchase 
IAPManager - протокол, описывает интерфейс взаимодействия с in-app purchase продуктами (покупка, восстановление покупок, доступ к чеку и продуктам)
IAPActionResult - результат операции покупки

4. ApplicationAnonymousID
ApplicationAnonymousID - хранилище anonymousId для фиче-приложения 

5. ABTests
ABTestsOutput - набор параметров теста 
ABTestsManager - протокол, описывает интерфейс взаимодействия с AB-тестированием 
