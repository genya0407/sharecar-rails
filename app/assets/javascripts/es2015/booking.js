/*
import MaterialDateTimePicker from 'material-datetime-picker';

const inputs = document.querySelectorAll('.datetimepicker');

inputs.forEach((input) => {
	const picker = new MaterialDateTimePicker()
	    .on('submit', (val) => {
	      input.value = val.format("DD/MM/YYYY");
	    });

	input.addEventListener('focus', () => picker.open());
});
*/

$('.datepicker').pickadate({
	selectMonths: true, // Creates a dropdown to control month
	selectYears: 15, // Creates a dropdown of 15 years to control year
    monthsFull: [ '1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月' ],
    monthsShort: [ '1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月' ],
    weekdaysFull: [ '日曜' , '月曜', '火曜', '水曜', '木曜', '金曜', '土曜'],
    weekdaysShort: [ '日曜' ,  '月曜', '火曜', '水曜', '木曜', '金曜', '土曜'],
    today: '今日',
    close: 'OK',
    clear: 'キャンセル',
    format: 'yyyy-mm-dd'
});