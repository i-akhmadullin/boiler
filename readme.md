# Бойлерплейт на основе grunt 0.4.1 #
  

## Установка ##
1. `npm install --silent`  
2. `grunt bower`  
3. `grunt` или `grunt livereload`  
4. `grunt publish`  
  
`grunt sprite` - сборка картинок с `_sprite` в конце названия файла в `publish/sprite.png`  
плюс файл координат для спрайта в `blocks/sprite_position.styl`. Стили не пересобирает!  
  
`grunt publish_img` - очищает `/publish` от картинок(кроме sprite.png),  
копирует в неё картинки из `/blocks` кроме картинок для спрайта и пожимает их.  
  
### Прочий бред ###
`ganam blocks --import blocks/i-mixins/i-mixins__gradients.styl -o styleguide` -  
генерирует стайлгайд в `/styleguide` из комментариев в папке `/blocks`.
  
`cd screenshots`, `casperjs screens.js` - делает скриншоты страниц.