'use strict';
'require view';
'require form';

return view.extend({
	render: function() {
		var m = new form.Map('l8x0gl', _('L8x0GL Configuration'), _('Configure Fibocom L850-GL/L860-GL MBIM backend.'));
		var s = m.section(form.NamedSection, 'global', 'l8x0gl', _('Connection'));
		s.option(form.Flag, 'enabled', _('Enable service'));
		s.option(form.Value, 'interface', _('Network interface'));
		s.option(form.Value, 'apn', _('APN'));
		s.option(form.Value, 'username', _('Username'));
		var pass = s.option(form.Value, 'password', _('Password'));
		pass.password = true;
		var auth = s.option(form.ListValue, 'auth', _('Authentication'));
		auth.value('none', _('None'));
		auth.value('pap', 'PAP');
		auth.value('chap', 'CHAP');
		var ipt = s.option(form.ListValue, 'iptype', _('IP type'));
		ipt.value('ipv4', 'IPv4');
		ipt.value('ipv6', 'IPv6');
		ipt.value('ipv4v6', 'IPv4/IPv6');
		s.option(form.Flag, 'auto_setup_network', _('Auto setup network'));
		s.option(form.Flag, 'auto_connect', _('Auto connect'));
		s.option(form.Value, 'monitor_interval', _('Monitor interval'));
		s.option(form.Value, 'boot_debounce', _('USB boot debounce'));
		s.option(form.Flag, 'allow_hard_reset', _('Allow hard reset'));

		var mb = m.section(form.NamedSection, 'mbim', 'mbim', _('MBIM'));
		mb.option(form.Value, 'device', _('MBIM device'));
		mb.option(form.Value, 'data_interface', _('Data interface'));
		mb.option(form.Flag, 'use_proxy', _('Use mbim-proxy'));
		mb.option(form.Flag, 'prefer_proxy_tools', _('Prefer proxy tools'));

		var es = m.section(form.NamedSection, 'esim', 'esim', _('eSIM'));
		es.option(form.Flag, 'enabled', _('Enable eSIM tools'));
		es.option(form.Value, 'lpac_bin', _('lpac binary'));
		var rs = es.option(form.ListValue, 'reconnect_on_switch', _('Reconnect after enable/switch'));
		rs.value('auto', _('Auto'));
		rs.value('1', _('Always'));
		rs.value('0', _('Never'));
		es.option(form.Value, 'operation_lock', _('Operation lock'));
		return m.render();
	}
});
