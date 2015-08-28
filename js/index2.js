(function() {
  $(function() {
    var Thumb, Top, UserAgent;
    Top = (function() {
      function Top() {
        this.$container = $('.js-container');
        this.$list = $('.js-thumb-list');
        this.$thumbItems = $('.js-thumb-items');
        this.THUMBS_NUM = 6;
        this.THUMB_WIDTH = 300;
        this.THUMB_HEIGHT = 200;
        this.FPS = 60;
        this.DELAY = 1000 / this.FPS;
        this.isTransform3d = false;
        this.thumbs = [];
        this.enterframeID = false;
        this.speed = 0;
        this.init();
      }

      Top.prototype.init = function() {
        return this.loadCompleted();
      };

      Top.prototype.loadCompleted = function() {
        var _self, i, tX, tY, thumb;
        _self = this;
        if ($('html').hasClass('csstransforms3d')) {
          _self.isTransform3d = true;
        }
        _self.$container.css({
          height: $(window).height()
        });
        i = 0;
        while (i < _self.THUMBS_NUM) {
          thumb = new Thumb(_self.THUMB_WIDTH, _self.THUMB_HEIGHT, _self.isTransform3d);
          _self.thumbs.push(thumb.get());
          _self.$list.append(_self.thumbs[i]);
          tX = Math.floor(Math.random() * window.innerWidth) - (this.THUMB_WIDTH / 2);
          tY = Math.floor(Math.random() * window.innerHeight) - (this.THUMB_HEIGHT / 2);
          _self.thumbs[i].css({
            transform: 'translate(' + tX + 'px, ' + tY + 'px)'
          });
          i++;
        }
        return $('body').on('mousewheel', _self, _self.mousewheelHandler);
      };

      Top.prototype.resizeHandler = function(e) {};

      Top.prototype.orientationchangeHandler = function(e) {};

      Top.prototype.scrollHandler = function(e) {};

      Top.prototype.mousewheelHandler = function(e, delta) {
        var _self;
        _self = e ? e.data : this;
        e.preventDefault();
        if (delta) {
          _self.speed += Math.round(delta);
          if (!_self.enterframeID) {
            return _self.enterframeID = setTimeout(function() {
              return _self.enterframeHandler(e, delta, _self);
            }, _self.DELAY);
          }
        }
      };

      Top.prototype.touchstartHandler = function(e) {};

      Top.prototype.touchmoveHandler = function(e) {};

      Top.prototype.enterframeHandler = function(e, delta, _self) {
        var RE_MAT, aX, aY, dir, i, j, m, mX, mY, tX, tY, thumb, windowHeight, windowWidth;
        if (_self.enterframeID) {
          clearTimeout(_self.enterframeID);
          _self.enterframeID = 0;
        }
        if (_self.speed) {
          windowWidth = $(window).width();
          windowHeight = $(window).height();
          i = 0;
          dir = {
            x: '',
            y: ''
          };
          RE_MAT = /matrix\(\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\s*\,\s*(-?\d+(?:\.\d+)?)\s*,\s*(-?\d+(?:\.\d+)?)\s*\)/;
          if (e.deltaY < 0) {
            dir.y = 'bottom';
          } else if (e.deltaY > 0) {
            dir.y = 'top';
          }
          if (e.deltaX < 0) {
            dir.x = 'right';
          } else if (e.deltaX > 0) {
            dir.x = 'left';
          }
          while (i < _self.THUMBS_NUM) {
            thumb = _self.thumbs[i];
            if (thumb) {
              m = thumb.css('transform').match(RE_MAT).slice(1);
              mX = parseFloat(m[4]);
              mY = parseFloat(m[5]);
              aX = thumb.attr('data-ax');
              aY = thumb.attr('data-ay');
              thumb.css({
                transform: 'translate(' + (mX + aX * (-e.deltaX * 0.4)) + 'px, ' + (mY + aY * (-e.deltaY * 0.5)) + 'px)'
              });
              if (mX < -thumb.width() || mX > windowWidth || mY < -thumb.height() || mY > windowHeight) {
                _self.thumbs[i].remove();
                _self.thumbs.splice(i, 1);
              }
            }
            i++;
          }
          if (_self.thumbs.length < _self.THUMBS_NUM) {
            thumb = new Thumb(_self.THUMB_WIDTH, _self.THUMB_HEIGHT, _self.isTransform3d);
            _self.thumbs.push(thumb.get());
            j = _self.thumbs.length - 1;
            _self.$list.append(_self.thumbs[j]);
            if (dir.x === 'left') {
              tX = windowWidth;
              tY = Math.floor(Math.random() * window.innerHeight) - _self.THUMB_HEIGHT;
            } else if (dir.x === 'right') {
              tX = -_self.THUMB_WIDTH;
              tY = Math.floor(Math.random() * window.innerHeight) - _self.THUMB_HEIGHT;
            }
            if (dir.y === 'top') {
              tX = Math.floor(Math.random() * window.innerWidth) - _self.THUMB_WIDTH;
              tY = windowHeight;
            } else if (dir.y === 'bottom') {
              tX = Math.floor(Math.random() * window.innerWidth) - _self.THUMB_WIDTH;
              tY = -_self.THUMB_HEIGHT;
            }
            _self.thumbs[j].css({
              transform: 'translate(' + tX + 'px, ' + tY + 'px)'
            });
          }
          dir.x = '';
          return dir.y = '';
        }
      };

      Top.prototype.loadCompleteHandler = function(e) {};

      Top.prototype.naviClickHandler = function(e) {};

      Top.prototype.closeClickHandler = function(e) {};

      return Top;

    })();
    Thumb = (function() {
      function Thumb(width, height, isTransform3d, target) {
        this.width = width;
        this.height = height;
        this.isTransform3d = isTransform3d;
        this.ax = (Math.random() * 2 + .5) * .5;
        this.ay = (Math.random() * 2 + .5) * .5;
      }

      Thumb.prototype.get = function() {
        var _self, elem;
        _self = this;
        if (this.isTransform3d) {
          elem = $('<li></li>', {
            addClass: 'thumb-items js-thumb-items'
          }).attr({
            'data-ax': _self.ax,
            'data-ay': _self.ay
          });
          return elem;
        } else {
          return console.info('This browser is not support Transform3d.');
        }
      };

      Thumb.prototype.remove = function(e) {};

      Thumb.prototype.move = function(e) {
        return console.log('Thumb.move() called.');
      };

      return Thumb;

    })();
    UserAgent = (function() {
      function UserAgent() {
        this.isMobile = false;
        this.isTablet = false;
        this.isDesktop = false;
        this.isWebkit = false;
        this.isFirefox = false;
        this.isIE = false;
      }

      return UserAgent;

    })();
    return window.onload = function() {
      return new Top();
    };
  });

}).call(this);
