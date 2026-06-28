'use strict';
'require view';
'require fs';
'require ui';

return view.extend({
	load: function() {
		return fs.read('/etc/owrt-full-backup/web.key').catch(function() {
			return '';
		});
	},

	render: function(key) {
		key = (key || '').trim();

		if (!key) {
			return E('div', { 'class': 'cbi-map' }, [
				E('h2', {}, _('OpenWrt Full Backup')),
				E('div', { 'class': 'alert-message warning' }, [
					_('Веб-ключ не найден. Переустанови модуль командой install.sh.')
				])
			]);
		}

		var url = '/cgi-bin/owrt-full-backup?key=' + encodeURIComponent(key);

		window.setTimeout(function() {
			window.location.replace(url);
		}, 100);

		return E('div', { 'class': 'cbi-map' }, [
			E('h2', {}, _('OpenWrt Full Backup')),
			E('p', {}, _('Открываю веб-панель полного бэкапа...')),
			E('p', {}, [
				E('a', { 'class': 'btn cbi-button cbi-button-apply', 'href': url }, _('Открыть панель'))
			])
		]);
	},

	handleSaveApply: null,
	handleSave: null,
	handleReset: null
});
