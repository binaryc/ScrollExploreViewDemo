# ScrollExploreViewDemo
##简介
很多应用中的首页物品推荐界面，能手动滑动，也能自动跳转切换。
##部分属性介绍
 switchItemSpaceTime属性代表在自动切换时间间隔。
 
 isAutomaticSwitch属性表示是否允许自动切换。
##部分方法介绍
实现对应的代理方法，能够响应点击视图方法。

目前setPageItem:方法只允许传UIImage数组。
##缺陷
由于setPageItem:方法只允许传UIImage数组所以，该Demo有些小残缺，可扩展性不强，若想丰富展示页面，可以根据自身的需求自定义PageItem。
