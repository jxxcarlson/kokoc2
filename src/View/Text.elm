module View.Text exposing (..)


loremIpsum =
    """
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce ut varius quam. Vestibulum in nibh faucibus, eleifend turpis eu, pharetra risus. Integer odio nisl, dignissim vel aliquet vitae, vehicula iaculis ligula. In vel arcu non magna aliquam euismod quis a magna. Aliquam non ligula vestibulum urna aliquam ullamcorper. Sed et vestibulum metus. Donec id risus vel arcu scelerisque pharetra eget egestas diam. Donec gravida arcu nec faucibus elementum. Nullam vulputate tellus libero, eget convallis diam porttitor eu. Vivamus nibh est, fermentum et convallis sed, scelerisque vel nisl. Donec in ligula at velit tincidunt hendrerit. Maecenas nec mauris sit amet enim semper tincidunt. Nunc a dolor tempus, bibendum libero eget, volutpat nulla. Pellentesque quis massa sed ex bibendum vulputate eu vitae arcu.

Pellentesque facilisis luctus augue, vel varius lorem ullamcorper ac. Fusce auctor orci eget augue suscipit, non eleifend leo dapibus. Sed venenatis arcu ut magna luctus imperdiet. Donec sagittis convallis leo. Cras sollicitudin ultricies ligula et eleifend. Quisque in eleifend est, in ultrices quam. Sed tempus orci neque, id accumsan lectus sagittis vitae. Curabitur porta quam vitae arcu sodales, ut placerat mauris condimentum. Nulla quis mollis odio. Curabitur sit amet tincidunt turpis. Ut cursus diam et nulla commodo, sed viverra nulla sodales. Aliquam erat volutpat. Proin non pulvinar leo. Mauris eu pharetra orci. Vestibulum pretium ornare condimentum. Sed id maximus magna.

Sed viverra nec tellus eget congue. Praesent cursus ex eu ex aliquam dapibus. Sed id nibh sagittis, auctor massa id, mattis ex. Vestibulum vel sapien suscipit, viverra urna vel, vulputate neque. Pellentesque facilisis tortor nec arcu lacinia, eget pretium est ornare. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Fusce sollicitudin sodales orci, vel aliquam enim porta sit amet.

Phasellus ac faucibus arcu. Aenean vel ullamcorper magna. Suspendisse potenti. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec at elementum diam, nec dapibus nibh. Aliquam in pellentesque quam. Maecenas faucibus commodo eros id tincidunt. Donec tristique posuere ornare. Suspendisse eget odio lobortis, pharetra dui aliquet, interdum lectus.

Aenean turpis metus, suscipit id ligula eu, placerat commodo mi. Proin aliquam elit posuere arcu sodales, ac ultrices neque eleifend. Vivamus lorem tortor, elementum sed dui sed, condimentum hendrerit leo. Vivamus at lorem augue. Suspendisse potenti. Phasellus ut tristique enim. Nulla porttitor libero at molestie egestas. Ut tincidunt, nunc ac vulputate faucibus, dolor tellus ornare nisi, maximus consequat urna eros dignissim ante. Aliquam sagittis nisl urna, nec sollicitudin massa tempus vitae. Aliquam suscipit diam vitae tortor malesuada hendrerit. Aliquam vitae placerat lacus, ut faucibus felis. Praesent pellentesque pretium faucibus. Suspendisse dictum accumsan nibh eget egestas. Ut eleifend ultricies nunc, in pharetra dolor accumsan et. Nunc consectetur pharetra ante vitae rutrum. Donec bibendum, justo ut luctus fermentum, libero velit lobortis diam, vel commodo lorem turpis ac augue.
"""


paragraphify element text =
    text
        |> String.split ("\n")
        |> List.filter (\x -> x /= "")
        |> List.map element
