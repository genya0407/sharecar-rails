// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery_ujs
//= require materialize
//= require_tree .

document.addEventListener('DOMContentLoaded', function() {
  let elems = document.querySelectorAll('.datepicker');
  let options = {
    i18n: {
      months: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
      monthsShort: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
      weekdays: ['日曜' , '月曜', '火曜', '水曜', '木曜', '金曜', '土曜'],
      weekdaysShort: ['日曜' , '月曜', '火曜', '水曜', '木曜', '金曜', '土曜'],
      weekdaysAbbrev: ['日' , '月', '火', '水', '木', '金', '土'],
      today: '今日',
      close: 'OK',
      clear: 'キャンセル',
    },
    format: 'yyyy-mm-dd'
  };
  M.Datepicker.init(elems, options);
});

document.addEventListener('DOMContentLoaded', function() {
  let elems = document.querySelectorAll('.sidenav');
  M.Sidenav.init(elems, {});
});

$(document).ready(function(){
  $('select').formSelect();
});
