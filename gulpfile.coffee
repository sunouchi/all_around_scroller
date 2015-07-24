autoprefixer  = require 'gulp-autoprefixer'
browser       = require 'browser-sync'
coffee        = require 'gulp-coffee'
gulp          = require 'gulp'
htmlhint      = require 'gulp-htmlhint'
jshint        = require 'gulp-jshint'
pleeease      = require 'gulp-pleeease'
plumber       = require 'gulp-plumber'
rename        = require 'gulp-rename'
sass          = require 'gulp-sass'
sftp          = require 'gulp-sftp'
uglify        = require 'gulp-uglify'

# Server
gulp.task 'server', () ->
  browser
    server :
      baseDir : './'
    open : 'external'
  # watch
  gulp.watch('sass/**/*scss', ['sass', 'reload'])
  gulp.watch('**/*.html', ['reload'])
  gulp.watch('coffee/**/*coffee', ['coffee', 'reload'])
  gulp.watch(['js/**/*js', '!js/min/**/*js'], ['js', 'reload'])

# Reload
gulp.task 'reload', () ->
  browser.reload()

# Sass
gulp.task 'sass', () ->
  gulp.src 'sass/**/*scss'
    .pipe plumber()
    .pipe sass()
    .pipe autoprefixer()
    .pipe pleeease()
    .pipe rename
      suffix : '.min'
    .pipe gulp.dest './css'
    .pipe browser.reload
      stream : true

# JavaScript
gulp.task 'js', () ->
  gulp.src ['js/**/*js', '!js/min/**/*js']
    .pipe plumber()
    .pipe uglify()
    .pipe gulp.dest './js/min'
    .pipe browser.reload
      stream : true

# CoffeeScript
gulp.task 'coffee', () ->
  gulp.src 'coffee/**/*coffee'
    .pipe plumber()
    .pipe coffee()
    # .pipe uglify()
    .pipe gulp.dest './js'
    .pipe browser.reload
      stream : true

# Default
gulp.task 'default', ['server']
