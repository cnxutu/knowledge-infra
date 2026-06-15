# 字典发现框架使用指南

> **目标读者**：使用 2.0.1 框架的业务开发  
> **适用范围**：所有基于 star-framework 2.0.1 的业务工程

---

## 1. 依赖引入

```xml
<dependency>
    <groupId>com.xmkj.framework</groupId>
    <artifactId>fw-spring-boot-starter-dict-discovery</artifactId>
</dependency>
```

> 已包含在 `fw-dependencies` BOM 中，无需指定版本。

---

## 2. 自动上报机制

启动时自动执行：**扫描 → 收集 → 排序 → RPC 同步到 c-system**

无需手动操作，只需在枚举上添加注解即可。

---

## 3. 用法模式

### 3.1 简单枚举（最常用）

```java
import com.xmkj.framework.dict.discovery.annotation.DictType;
import com.xmkj.framework.dict.discovery.annotation.DictItem;

@Getter
@AllArgsConstructor
@DictType(type = "device_status", name = "设备状态")
public enum DeviceStatusEnum {

    @DictItem(label = "未激活", value = "0", sort = 1)
    INACTIVE(0),

    @DictItem(label = "在线", value = "1", sort = 2)
    ONLINE(1),

    @DictItem(label = "离线", value = "2", sort = 3)
    OFFLINE(2);

    private final Integer code;
}
```

### 3.2 部分枚举项上报

如果枚举中有些项不需要出现在字典中，可以只给需要上报的项加 `@DictItem`：

```java
@Getter
@RequiredArgsConstructor
@DictType(type = "operator_type", name = "操作符类型")
public enum OperatorTypeEnum {

    @DictItem(label = "等于", value = "=", sort = 1)
    EQUALS("="),

    @DictItem(label = "不等于", value = "!=", sort = 2)
    NOT_EQUALS("!="),

    // 以下两项不加 @DictItem，不会上报到字典
    INTERNAL_A("internal_a"),
    INTERNAL_B("internal_b");

    private final String value;
}
```

### 3.3 非连续值枚举

```java
@Getter
@RequiredArgsConstructor
@DictType(type = "data_sink_type", name = "数据下发类型")
public enum DataSinkTypeEnum {

    @DictItem(label = "HTTP", value = "1", sort = 1)
    HTTP(1),

    @DictItem(label = "TCP", value = "2", sort = 2)
    TCP(2),

    @DictItem(label = "MQTT", value = "10", sort = 3)
    MQTT(10),

    @DictItem(label = "数据库", value = "20", sort = 4)
    DATABASE(20);

    private final Integer code;
}
```

### 3.4 编程式定义（外部 SDK 枚举）

如果字典项来自外部 SDK 的枚举（无法加注解），使用 `DictTypeInfoProvider`：

```java
@Component
public class SdkDictTypeInfoProvider extends DictTypeInfoProvider {

    @Override
    public Collection<DictTypeSyncDTO> provideDictTypes() {
        DictTypeSyncDTO dto = new DictTypeSyncDTO();
        dto.setType("external_device_type");
        dto.setName("外部设备类型");

        List<DictDataSyncDTO> items = Arrays.asList(
            createItem("温湿度传感器", "1", 1),
            createItem("烟雾报警器", "2", 2),
            createItem("智能门锁", "3", 3)
        );
        dto.setItems(items);
        return Collections.singletonList(dto);
    }

    private DictDataSyncDTO createItem(String label, String value, int sort) {
        DictDataSyncDTO item = new DictDataSyncDTO();
        item.setLabel(label);
        item.setValue(value);
        item.setSort(sort);
        item.setStatus(1);  // 1=启用
        return item;
    }
}
```

---

## 4. 注解参数说明

| 注解 | 参数 | 必填 | 说明 |
|------|------|------|------|
| `@DictType` | `type` | ✅ | 字典类型编码（唯一标识） |
| `@DictType` | `name` | ✅ | 字典类型显示名称 |
| `@DictType` | `appCode` | ❌ | 应用编码，默认取 `spring.application.name` |
| `@DictType` | `description` | ❌ | 字典描述 |
| `@DictItem` | `label` | ✅ | 显示文本 |
| `@DictItem` | `value` | ✅ | 存储值 |
| `@DictItem` | `sort` | ❌ | 排序号，默认按枚举声明顺序 |
| `@DictItem` | `colorType` | ❌ | 颜色类型（如 `success`、`error`） |
| `@DictItem` | `enabled` | ❌ | 是否启用，默认 `true` |

---

## 5. 与 1.x 字典管理的区别

| 维度 | 1.x | 2.0.1 |
|------|-----|-------|
| 字典定义 | 手动在数据库 / Nacos 配置 | 代码注解定义，启动自动上报 |
| 维护成本 | 需手动同步枚举和字典数据 | 枚举变更自动同步 |
| 多应用冲突 | 需手动区分应用编码 | 自动按 `spring.application.name` 隔离 |
| 字典校验 | 无 | 增加类型、名称、标签、键值重复性校验 |
