# array\_map(),array\_filter(),array\_walk()的区别

-   array\_map &#x20;
    > 数组中的每个元素应用自定义函数，返回新数组，不改变原数组，可对多个数组操作
    ```php
    <?php
    function myfunction($v1,$v2)
    {
        if ($v1===$v2)
        {
           return "same";
        }
        return "different";
    }

    $a1=array("Horse","Dog","Cat");
    $a2=array("Cow","Dog","Rat");
    print_r(array_map("myfunction",$a1,$a2));
    ?>
    ```
    输出结果：Array ( \[0] => different \[1] => same \[2] => different )
-   array\_walk &#x20;
    > 数组中的每个元素应用用户自定义函数，只返回bool型，但是可以获取健名和键值，并且可以对函数的第一个参数指定为引用 `&$value`&#x20;
    ```php
    <?php
    function myfunction(&$value,$key)
    {
      $value="yellow";
    }
    $a=array("a"=>"red","b"=>"green","c"=>"blue");
    array_walk($a,"myfunction");
    print_r($a);
    ?>

    ```
    输出结果：Array ( \[a] => yellow \[b] => yellow \[c] => yellow )
-   array\_filter &#x20;
    > 对数组元素进行过滤，只有函数返回为真才保留，生成新数组，原数组不影响
    ```php
    <?php
    function test_odd($var)
    {
      return($var % 2 == 0);
    }

    $a1=array(1,2,3,4);
    print_r(array_filter($a1,"test_odd"));
    ?>
    ```
    输出结果：Array ( \[1] => 2 \[3] => 4 )
