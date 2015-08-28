$ ->
  class Top
    constructor: ->
      # element
      @.$container = $('.js-container')
      @.$list = $('.js-thumb-list')
      @.$thumbItems = $('.js-thumb-items')

      # constant
      @.THUMBS_NUM = 6
      @.THUMB_WIDTH = 300 #TODO: あとで変える
      @.THUMB_HEIGHT = 200 #TODO: あとで変える
      @.FPS = 60
      @.DELAY = 1000 / @.FPS

      # parameter
      @.isTransform3d = false
      @.thumbs = []
      @.enterframeID = false
      @.speed = 0;

      @.init()

    init: () ->
      @.loadCompleted()

    loadCompleted: () ->
      _self = @

      # CSS3パラメータの有効/無効をチェック
      if $('html').hasClass('csstransforms3d')
        _self.isTransform3d = true

      # スタイルの設定
      _self.$container.css
        height : $(window).height()

      # imageの配置
      i = 0
      while i < _self.THUMBS_NUM
        thumb = new Thumb(_self.THUMB_WIDTH, _self.THUMB_HEIGHT, _self.isTransform3d)
        _self.thumbs.push(thumb.get())
        _self.$list.append(_self.thumbs[i])
        tX = Math.floor(Math.random() * window.innerWidth) - (@.THUMB_WIDTH / 2)
        tY = Math.floor(Math.random() * window.innerHeight) - (@.THUMB_HEIGHT / 2)
        _self.thumbs[i].css({
          transform: 'translate(' + tX + 'px, ' + tY + 'px)'          
        })
        i++

      # イベントハンドラ設定
      $('body').on 'mousewheel', _self, _self.mousewheelHandler


    resizeHandler: (e) ->

    orientationchangeHandler: (e) ->

    scrollHandler: (e) ->

    mousewheelHandler: (e, delta) ->
      _self = if e then e.data else @
      e.preventDefault()
      if delta
        # タイマー処理
        _self.speed += Math.round(delta)
        if !_self.enterframeID
          _self.enterframeID = setTimeout () ->
            _self.enterframeHandler(e, delta, _self)
          , _self.DELAY

    touchstartHandler: (e) ->

    touchmoveHandler: (e) ->

    enterframeHandler: (e, delta, _self) ->
      # enterframeIDをクリア
      if _self.enterframeID
        clearTimeout(_self.enterframeID)
        _self.enterframeID = 0

      # thumbを移動させる
      if _self.speed
        windowWidth = $(window).width()
        windowHeight = $(window).height()

        # thumbの移動と削除
        i = 0
        dir =
          x : ''
          y : ''            
        RE_MAT = /matrix\(\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\s*\,\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\s*\)/;

        # スクロール方向の判定
        if e.deltaY < 0
          dir.y = 'bottom'
        else if e.deltaY > 0
          dir.y = 'top'
        if e.deltaX < 0
          dir.x = 'right'
        else if e.deltaX > 0
          dir.x = 'left'

        while i < _self.THUMBS_NUM
          thumb = _self.thumbs[i]
          if thumb
            # thumbを動かす
            m = thumb.css('transform').match(RE_MAT).slice(1)
            mX = parseFloat(m[4])
            mY = parseFloat(m[5])
            aX = thumb.attr('data-ax')
            aY = thumb.attr('data-ay')
            thumb.css
              transform: 'translate(' + (mX + aX * (-e.deltaX * 0.4)) + 'px, ' + (mY + aY * (-e.deltaY * 0.5)) + 'px)'
            # thumbを削除
            if mX < -thumb.width() || mX > windowWidth || mY < -thumb.height() || mY > windowHeight
              _self.thumbs[i].remove()
              _self.thumbs.splice(i, 1)
          i++

        # thumbの追加
        if _self.thumbs.length < _self.THUMBS_NUM
          # 変数とDOMに追加
          thumb = new Thumb(_self.THUMB_WIDTH, _self.THUMB_HEIGHT, _self.isTransform3d)
          _self.thumbs.push(thumb.get())
          j = _self.thumbs.length - 1
          _self.$list.append(_self.thumbs[j])

          # スタイル設定
          if dir.x == 'left'
            tX = windowWidth
            tY = Math.floor(Math.random() * window.innerHeight) - _self.THUMB_HEIGHT
          else if dir.x == 'right'
            tX = -_self.THUMB_WIDTH
            tY = Math.floor(Math.random() * window.innerHeight) - _self.THUMB_HEIGHT
          if dir.y == 'top'
            tX = Math.floor(Math.random() * window.innerWidth) - _self.THUMB_WIDTH
            tY = windowHeight
          else if dir.y == 'bottom'
            tX = Math.floor(Math.random() * window.innerWidth) - _self.THUMB_WIDTH
            tY = -_self.THUMB_HEIGHT
          _self.thumbs[j].css({
            transform: 'translate(' + tX + 'px, ' + tY + 'px)'          
          })

        dir.x = ''
        dir.y = ''

    loadCompleteHandler: (e) ->

    naviClickHandler: (e) ->

    closeClickHandler: (e) ->    




  class Thumb
    constructor: (width, height, isTransform3d, target) ->
      @.width = width
      @.height = height
      @.isTransform3d = isTransform3d
      @.ax = (Math.random() * 2 + .5) * .5
      @.ay = (Math.random() * 2 + .5) * .5

    get: () ->
      _self = @
      if @.isTransform3d
        elem = $ '<li></li>', {
          addClass : 'thumb-items js-thumb-items'
        }
          .attr
            'data-ax' : _self.ax 
            'data-ay' : _self.ay
        return elem
      else 
        console.info('This browser is not support Transform3d.')

    remove: (e) ->
      return
      
    move: (e) ->
      console.log('Thumb.move() called.')
      # return



  class UserAgent
    constructor: () ->
      # ウィンドウ横幅の判定
      @.isMobile = false
      @.isTablet = false
      @.isDesktop = false

      # ブラウザの判定
      @.isWebkit = false
      @.isFirefox = false
      @.isIE = false



  window.onload = ->
    new Top()
