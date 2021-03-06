# SolarEngine iOS SDK

[![CI Status](https://img.shields.io/travis/leopardpan/BXSESDK.svg?style=flat)](https://travis-ci.org/leopardpan/BXSESDK)
[![Version](https://img.shields.io/cocoapods/v/BXSESDK.svg?style=flat)](https://cocoapods.org/pods/BXSESDK)
[![License](https://img.shields.io/cocoapods/l/BXSESDK.svg?style=flat)](https://cocoapods.org/pods/BXSESDK)
[![Platform](https://img.shields.io/cocoapods/p/BXSESDK.svg?style=flat)](https://cocoapods.org/pods/BXSESDK)



## 一、说明

SolarEngine 是一套支持高度自定义的数据分析系统，系统在数据埋点、属性设置、报表创建、看板配置等多方面都支持开发者按需求进行个性化定制。

本文档将针对 SDK 端的数据上报进行说明，帮助您进行数据接入。

SolarEngine iOS SDK 适用于 iOS 9.0 及以上的操作系统。


**隐私权政策：**<https://portal.solar-engine.com/privacyPolicy>


## 二、接入流程


### 1. 申请 AppKey & userID

报送数据需要 AppKey 及 userID，负责人账号管登录热力引擎系统系统后可自行查询  

查询路径：

- AppKey 查询路径：资产管理-应用管理-16位 AppKey（即应用 ID）

![](https://s4.ax1x.com/2022/02/21/Hj62l9.png)

- userID 查询路径：账户管理-账号信息-密钥-16 位 userID

![](https://s4.ax1x.com/2022/02/21/Hj64w6.png)
 

### 2、使用Cocoapods集成SDK

```
pod 'BXSESDK'
```

## 三、接入方法说明

### 1. 初始化 SDK

用于应用启动后，初始化 SDK。

```
- (void)setAppKey:(nonnull NSString *)appKey withSEUserId:(nonnull NSString *)SEUserId;
```

参数说明：

| **参数** | **类型**   | **是否必填** |  **说明**                             |
| ------- | :--------- | :----------- | :----------------------------------- |
| appKey   | NSString * | 是              | 应用 appKey，请联系商务人员获取。 |
| SEUserId      | NSString * | 是           | 用户 ID   ，请联系商务人员获取。             |

示例代码：

```
[[SolarEngineSDK sharedInstance] setAppKey:@"your_appKey" withSEUserId:@"your_userId"];
```

### 2.开启 Debug 模式

用于打印 Debug 阶段日志。

```
- (void)setDebugModel:(BOOL)isDebug;
```

参数说明：

| **参数** | **类型**   | **是否必填** |  **说明**                             |
| ------- | --------- | ----------- | ----------------------------- |
| isDebug   | BOOL | 是              | YES 表示开启 Debug 模式，NO 表示关闭 Debug 模式。上线前请设置为 NO。不调用该方法，不开启 Debug 模式 |        

示例代码：

```
[[SolarEngineSDK sharedInstance] setDebugModel:YES];
```

### 3.设置 Custom URL

设置自定义 URL。**需在 SDK 初始化之前调用**。

```
- (void)setCustomURLString:(NSString *)urlString;
```

参数说明：

| **参数** | **类型**   | **是否必填** |  **说明**                             |
| ------- | --------- | ----------- | ----------------------------- |
| urlString   | NSString | 是              | 自定义 URL |      

示例代码：

```
[[SolarEngineSDK sharedInstance] setCustomURLString:@"https://xxx.xxx.com"];
```

### 4.设置手动上报应用安装事件

**需在 SDK 初始化之前调用**。

```
- (void)setIsTrackInstallEventManually:(BOOL)isTrackInstallEventManually;
```

参数说明：

| **参数** | **类型**   | **是否必填** |  **说明**                             |
| ------- | --------- | ----------- | ----------------------------- |
| isTrackInstallEventManually   | BOOL | 是              |  默认不设置时为 NO，初始化 SDK 后自动上报应用安装（_appInstall） 事件。<br> 如果设置为 YES，需要主动调用 - (void)trackAppInstall 方法上报应用安装（_appInstall）事件。|      

示例代码：

```
[[SolarEngineSDK sharedInstance] setIsTrackInstallEventManually:YES];
```

### 5.访客 ID & 账号 ID

#### 5.1 访客 ID

指用户在设备上安装了应用之后，登录状态之前该用户的唯一标识。

SDK 会用设备标识或随机生成唯一 ID 的方式作为访客 ID，该 ID 在首次生成后会被缓存，卸载重新安装应用不会改变访客 ID。

我们提供访客 ID 自定义设置的接口，如果您有自己的访客管理体系需要替换访客 ID，应在 SDK 初始化之后立即进行调用。

数据上报时仅以最后一次传入的访客 ID 为准，应避免多次调用造成多个非正常访客 ID 先后上报数据的情况。

- **设置访客 ID**

调用 `setVisitorID:` 来设置访客 ID：

```Objective-C
// 设置访客 ID 为 vid8709901241
[[SolarEngineSDK sharedInstance] setVisitorID:@"vid8709901241"];
```

注意，该调用仅为向 SDK 传入访客 ID，不会上报用户设置事件。

- **获取访客 ID**

如果您需要获取当前访客 ID，可以调用 `getVisitorId` 获取：

```Objective-C
// 返回访客 ID，多实例的情况下，返回的是调用实例的访客 ID
NSString *visitorId = [[SolarEngineSDK sharedInstance] visitorID];
```

#### 5.2 账号 ID

指用户在应用中登录之后，登录账号在应用中的唯一标识。登录之前将以访客 ID 作为用户标识。

在账号 ID 设置完成后，在调用 `logout` 清除账号 ID之前，设置的账号 ID 将一直保留，并作为用户身份识别 ID。清除账号 ID 的操作请在有真实退出登录状态行为时进行，关闭 App、退至后台运行时无需调用。

数据上报时仅以最后一次传入的账号 ID 为准，应避免多次调用造成多个非正常账号 ID 先后上报数据的情况。

- **设置账号 ID**

调用 `login` 来设置用户的账号 ID：

```Objective-C
[[SolarEngineSDK sharedInstance] loginWithAccountID:@"aid25491084"];
```

注意：该调用仅为向 SDK 传入账号 ID，不会上报用户登录事件。

- **获取账号 ID**

调用 `getAccountId` 来获取用户的账号 ID：

```Objective-C
NSString *accountID = [[SolarEngineSDK sharedInstance] accountID];
```

- **清除账号 ID**

调用 `logout` 来清除账号 ID：

```Objective-C
[[SolarEngineSDK sharedInstance] logout];
```

注意：该调用仅为通知 SDK 清除账号 ID，不会上报用户登出事件。

### 6.事件上报

在 SDK 初始化完成之后，您就可以调用下面方法来上报事件。

#### 6.1 设置公共事件属性

对于一些重要的属性，譬如用户的会员等级、来源渠道等，这些属性需要设置在每个事件中，此时您可以将这些属性设置为公共事件属性。

公共事件属性指的就是每个事件都会带有的属性，您可以调用 `setSuperProperties` 来设置公共事件属性，我们推荐您在发送事件前，先设置公共事件属性。

公共事件属性的格式要求与事件属性一致。

```Objective-C
// 设置公共事件属性
NSDictionary *properties = @{@"vip_level":@(2)
                                 ,@"Channel":@"A1"};
[[SolarEngineSDK sharedInstance] setSuperProperties:properties];
```


如果您需要删除某个公共事件属性，您可以调用 `unsetSuperProperty` 清除其中一个公共事件属性；如果您想要清空所有公共事件属性，则可以调用 `clearSuperProperties`。

```Objective-C
// 清除一条公共事件属性，比如将之前设置 "Channel" 属性清除，之后的数据将不会该属性
[[SolarEngineSDK sharedInstance] unsetSuperProperty:@"Channel"];

// 清除所有公共事件属性
[[SolarEngineSDK sharedInstance] clearSuperProperties];
```

####6.2 预定义事件

#####6.2.1 上报变现广告展示事件

App 内变现广告展示时，报送该事件，用于进行广告展示及变现收入分析。

```
- (void)trackAdImpressionWithAttributes:(SEAdImpressionEventAttribute *)attribute;
```

`SEAdImpressionEventAttribute` 类参数介绍:

参数名称 | 参数含义 | 参数类型 | 是否可以为空
:-: | :-: | :-: | :-:
adNetworkPlatform |  变现平台名称，枚举值如下（传值传前面的枚举简称即可）：<br> csj：穿山甲、ylh：优量汇、bqt：百青藤、ks：快手<br> sigmob：Sigmob、mintegral：Mintegral、oneway：OneWay、vungle：Vungle、facebook：Facebook、admob：AdMob、unity：UnityAds、is：IronSource、adtiming：AdTiming、klein：游可赢等| NSString | 否
adType | 展示广告的类型，枚举值如下（传值传前面的枚举简称即可）：<br>1：激励视频、2：开屏、3：插屏、4：全屏视频、5：Banner、6：信息流、7：短视频信息流、8：大横幅 、9：视频贴片、10：其它| SolarEngineAdType | 否
adNetworkAppID | 变现平台的应用 ID|NSString | 否
adNetworkPlacementID | 变现平台的变现广告位 ID|NSString | 否
ecpm | 广告ECPM（广告千次展现的变现收入，0或负值表示没传）|double | 否
currency | 展示收益的货币种类，遵循《ISO 4217国际标准》，如 CNY、USD|NSString | 否
rendered | 广告是否渲染成功,具体枚举值如下：<br>YES：成功、NO：失败|BOOL | 否


**注：如果开发者不需要统计 rendered 参数，传 YES 即可。**


示例代码:

```
SEAdImpressionEventAttribute *attribute = [[SEAdImpressionEventAttribute alloc] init];
attribute.adNetworkPlatform = SEMonetizationPlatformNameCSJ;
attribute.adType = SolarEngineAdTypeRewardVideo;
attribute.adNetworkAppID = @"test_adNetworkAppID";
attribute.adNetworkPlacementID = @"test_adNetworkPlacementID";
attribute.currency = @"USD";
attribute.ecpm = 13.14;
attribute.rendered = YES;
[[SolarEngineSDK sharedInstance] trackAdImpressionWithAttributes:attribute];
```

#####6.2.2 上报应用内购买事件

App 内付费购买时，报送该事件，用于进行购买及内购收入分析


```
- (void)trackIAPWithAttributes:(SEIAPEventAttribute *)attribute;
```

`SEIAPEventAttribute` 类参数介绍:

参数名称 | 参数含义 | 参数类型 | 是否可以为空
:-: | :-: | :-: | :-:
orderId |  本次购买由系统生成的订单 ID| NSString | 否
payAmount | 本次购买支付的金额| double | 否
currencyType | 支付的货币各类，遵循《ISO 4217国际标准》，如 CNY、USD | NSString | 否
payType | 支付方式：如 alipay、weixin、applepay、paypal 等| NSString | 否
productID | 购买商品的ID | NSString | 否
productName | 商品名称 | NSString | 否
productCount | 购买商品的数量| NSInteger | 否
payStatus | 支付状态,具体枚举值如下（传值传前面的枚举简称即可）：<br> SolarEngineIAPSuccess:成功 SolarEngineIAPFail:失败、SolarEngineIAPRestored:恢复|SolarEngineIAPStatus | 否
failReason |  支付失败的原因| NSString | 是


**注：支付失败原因failReason参数仅在 payStatus 参数为 SolarEngineIAPFail 支付失败时才会传入，其他状态传""即可。**


调用示例代码:

```
SEIAPEventAttribute *attribute = [[SEIAPEventAttribute alloc] init];
attribute.productID = @"test_productID";
attribute.productName = @"test_productName";
attribute.productCount = 1234;
attribute.orderId = @"test_orderID";
attribute.payAmount = 123456;
attribute.currencyType = @"CNY";
attribute.payType = SEIAPEventPayTypeWeixin;
attribute.payStatus = SolarEngineIAPFail;
attribute.failReason = @"test_failReason";
[[SolarEngineSDK sharedInstance] trackIAPWithAttributes:attribute];
```

#### 6.3 自定义事件

您可以调用 `track:withProperties:` 来上报事件，建议您根据先前梳理的文档来设置事件的属性以及发送信息的条件，此处以用户购买某商品作为范例：

```Objective-C
// 商店购买事件
NSDictionary *properties = @{ @"product_name" : @"商品名",
									@"product_num" : @(1),
                              @"cost":@(100),
									@"isFirstBuy":@(true)
								  };
[[SolarEngineSDK sharedInstance] track:@"isFirstBuy" withProperties:properties];
```

事件的名称是 `NSString` 类型，只能以字母开头，可包含数字，字母和下划线 "_"，长度最大为 40 个字符，对字母大小写不敏感。

- 事件的属性是一个 `NSDictionary` 对象，其中每个元素代表一个属性。

- Key 的值为属性的名称，为 `NSString` 类型，规定只能以字母开头，包含数字，字母和下划线 "_"，长度最大为 40 个字符，对字母大小写不敏感。

- Value 为该属性的值，支持 `NSString`、`NSNumber` 和 `NSArray`。 对于 `NSArray` 的元素，只支持字符串类型，对于其他类型都将强制转为字符串存储。


#### 6.4 时长事件

如果您需要记录某个事件的持续时长，可以调用 `eventStart:` 来开始计时，配置您想要计时的事件名称，当您结束该事件时，需要调用 `eventFinish:properties:`，它将会自动在您的事件属性中加入 `_duration` 这一属性来表示记录的时长，单位为秒。需要注意的是，同一个事件名只能有一个在计时的任务。

```Objective-C
// 用户进入商品页面，开始计时，记录的事件为 "Enter_Shop"
[[SolarEngineSDK sharedInstance] eventStart:@"Enter_Shop"];
// 设置事件属性，用户浏览的商品ID
NSDictionary *properties = @{ @"product_id" : @"A1354" };
// 上传事件，计时结束，"Enter_Shop" 这一事件中将会带有表示事件时长的属性 _duration
[[SolarEngineSDK sharedInstance] eventFinish:@"Enter_Shop" properties:properties];
```

#### 6.5 应用安装事件

需配合 `- (void)setIsTrackInstallEventManually:(BOOL)isTrackInstallEventManually;` 且`isTrackInstallEventManually` 为 `YES` 时使用。

```
- (void)trackAppInstall;
```

示例代码：

```
[[SolarEngineSDK sharedInstance] trackAppInstall];
```

### 7.用户属性

平台目前支持的用户属性设置接口为 `userInit`、`userUpdate`、`userAdd`、`userUnset`、`userAppend`、`userDelete`。

#### 7.1 userInit

如果您要上传的用户属性只要设置一次，则可以调用 `userInit ` 来进行设置，当该属性之前已经有值的时候，将会忽略这条信息，以设置首次付费时间来为例：

```Objective-C
[[SolarEngineSDK sharedInstance] userInit:@{ @"Name" : @"Tom", @"City" : @"Beijing", @"Age" : @(18), @"Books" : @[@"b1", @"b2"] }];
```

#### 7.2 userUpdate

对于一般的用户属性，您可以调用 `userUpdate` 来进行设置，使用该接口上传的属性将会覆盖原有的属性值，如果之前不存在该用户属性，则会新建该用户属性，类型与传入属性的类型一致，此处以设置城市为例：

```Objective-C
[[SolarEngineSDK sharedInstance] userUpdate:@{ @"City" : @"Shenzhen" }];
// 此时 "City" 为"Shenzhen"
```

#### 7.3 userAdd

当您要上传数值型的属性时，您可以调用 `userAdd` 来对该属性进行累加操作，如果该属性还未被设置，则会赋值 0 后再进行计算，可传入负值，等同于相减操作。此处以累计付费金额为例：

```Objective-C
[[SolarEngineSDK sharedInstance] userAdd:@{ @"TotalRevenue" : @(30) }];
// 此时 "TotalRevenue" 为 30
[[SolarEngineSDK sharedInstance] userAdd:@{ @"TotalRevenue" : @(648) }];
// 此时 "TotalRevenue" 为 678
```

> `userAdd` 设置的属性类型以及 Key 值的限制与 `userUpdate` 一致，但 Value 只允许 `NSNumber` 类型。

#### 7.4 userUnset

当您要清空用户的用户属性值时，您可以调用 `userUnset` 来对指定属性（字符串数组）进行清空操作，如果该属性还未在集群中被创建，则 `unset` **不会**创建该属性

```Objective-C
[[SolarEngineSDK sharedInstance] userUnset:@[@"Age"]];
```

> `userUnset` 传入的参数是用户属性的属性名，类型是字符串数组。


#### 7.5 userAppend

您可以调用 `userAppend` 对数组类型的用户属性进行追加操作。

```Objective-C
// 调用 userAppend 为用户属性 Books 追加元素。如果不存在，会新建该元素
[[SolarEngineSDK sharedInstance] userAppend:@{ @"Books" : @[ @"b3", @"b4" ] }];
```

#### 7.6 userDelete

如果您要删除某个用户，可以调用 `userDelete` 将这名用户删除，您将无法再查询该名用户的用户属性，但该用户产生的事件仍然可以被查询到。

```Objective-C
[[SolarEngineSDK sharedInstance] userDelete];
```

