# JSON对象

## 函数

### json\_decode

> 对 JSON 格式的字符串进行解码

```php
json_decode(
    string $json,
    bool $assoc = false,
    int $depth = 512,
    int $options = 0
): mixed
```

-   `json`待解码的 `json` string 格式的字符串。这个函数仅能处理 UTF-8 编码的数据。
-   `assoc`当该参数为 **`true`** 时，将返回 array 而非 object 。
-   `depth`指定递归深度。
-   `options`

    由 **`JSON_BIGINT_AS_STRING`**, **`JSON_INVALID_UTF8_IGNORE`**, **`JSON_INVALID_UTF8_SUBSTITUTE`**, **`JSON_OBJECT_AS_ARRAY`**, **`JSON_THROW_ON_ERROR`** 组成的掩码。 这些常量的行为在[JSON constants](https://www.php.net/manual/zh/json.constants.php "JSON constants")页面有进一步描述。

### json\_encode

> 对变量进行 JSON 编码

```php
json_encode(mixed $value, int $options = 0, int $depth = 512): string|false
```

-   `value`待编码的 `value` ，除了 [资源(resource)](https://www.php.net/manual/zh/language.types.resource.php "资源(resource)") 类型之外，可以为任何数据类型。所有字符串数据的编码必须是 UTF-8
-   `options`

    由以下常量组成的二进制掩码： **`JSON_FORCE_OBJECT`**, **`JSON_HEX_QUOT`**, **`JSON_HEX_TAG`**, **`JSON_HEX_AMP`**, **`JSON_HEX_APOS`**, **`JSON_INVALID_UTF8_IGNORE`**, **`JSON_INVALID_UTF8_SUBSTITUTE`**, **`JSON_NUMERIC_CHECK`**, **`JSON_PARTIAL_OUTPUT_ON_ERROR`**, **`JSON_PRESERVE_ZERO_FRACTION`**, **`JSON_PRETTY_PRINT`**, **`JSON_UNESCAPED_LINE_TERMINATORS`**, **`JSON_UNESCAPED_SLASHES`**, **`JSON_UNESCAPED_UNICODE`**, **`JSON_THROW_ON_ERROR`**。 关于 JSON 常量详情参考 [JSON 常量](https://www.php.net/manual/zh/json.constants.php "JSON 常量")页面。
-   `depth`设置最大深度。 必须大于0。

## 取值

### object

```php
$json = '{"name":"NlinX"}';
$obj = json_decode($json);
echo $obj->name;
//或者  $obj->{"name"}
```

### array

```php
$json = '{"name":"NlinX"}';
$array = json_decode($json,true);
echo $array['name'];
```

<https://www.php.net/manual/zh/function.json-decode.php>
