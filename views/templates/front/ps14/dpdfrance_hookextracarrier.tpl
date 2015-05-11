{**
 * 2007-2015 PrestaShop
 *
 * NOTICE OF LICENSE
 *
 * This source file is subject to the Academic Free License (AFL 3.0)
 * that is bundled with this package in the file LICENSE.txt.
 * It is also available through the world-wide-web at this URL:
 * http://opensource.org/licenses/afl-3.0.php
 * If you did not receive a copy of the license and are unable to
 * obtain it through the world-wide-web, please send an email
 * to license@prestashop.com so we can send you a copy immediately.
 *
 * DISCLAIMER
 *
 * Do not edit or add to this file if you wish to upgrade PrestaShop to newer
 * versions in the future. If you wish to customize PrestaShop for your
 * needs please refer to http://www.prestashop.com for more information.
 *
 * @author    DPD S.A.S. <ensavoirplus.ecommerce@dpd.fr>
 * @copyright 2015 DPD S.A.S.
 * @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 *}

{if $opc == 0}
	{include file="$dpdfrance_tpl_path/relais/dpdfrance_relais_std.tpl"}
	{include file="$dpdfrance_tpl_path/predict/dpdfrance_predict_std.tpl"}
{else}
	{include file="$dpdfrance_tpl_path/relais/dpdfrance_relais_opc.tpl"}
	{include file="$dpdfrance_tpl_path/predict/dpdfrance_predict_opc.tpl"}
{/if}

<script type="text/javascript">
{literal}

$(document).ready(function(){
	$("input[name='id_carrier']").change(function(){
		checkedCarrier = $("input[name*='id_carrier']:checked").val();
		if ($('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked') || $('#id_carrier' + {/literal}{$dpdfrance_predict_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked'))
			$("#form").attr("action", baseDir+'modules/dpdfrance/validation.php?dpdfrance_carrier=' + checkedCarrier);
		else
			$("#form").attr("action", baseDir+'order.php');
	});
});

{/literal}
</script>