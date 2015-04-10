{**
 * 2007-2014 PrestaShop
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
 
 <script type="text/javascript">
    var badIE = false;
</script>

<!--[if lt IE 8]>
	<script type="text/javascript">badIE = true;</script>
<![endif]-->
<script type="text/javascript">
if (badIE == false){
	{literal}

	$(document).ready(function()
	{
		checkedCarrier = $("input[name*='id_carrier']:checked").val();
		if ($("#dpdfrance_div_relais_error").length==0)
		{
			var i;
			var tabInput = document.getElementsByName("dpdfrance_lignerelais");
			var n = 5;

			for (i=0; i<n; i++)
				document.getElementById("dpdfrance_lignerelais").id = 'dpdfrance_lignerelais'+i;

			$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).parent().parent().after("<tr><td colspan='4' style='padding:0; display:none;' id='tr_carrier_dpdfrance_relais'></td></tr>");

			dpdfrance_relais_response = [dpdfrance_div_relais_header,dpdfrance_lignerelais0,dpdfrance_lignerelais1,dpdfrance_lignerelais2,dpdfrance_lignerelais3,dpdfrance_lignerelais4]

			if ($('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked'))
			{
				$.when($('#dpdfrance_div_relais_header,#dpdfrance_lignerelais0,#dpdfrance_lignerelais1,#dpdfrance_lignerelais2,#dpdfrance_lignerelais3,#dpdfrance_lignerelais4').show('fast')).done(function()
				{
					$("#tr_carrier_dpdfrance_relais").html(dpdfrance_relais_response);
					$("#tr_carrier_dpdfrance_relais").fadeIn('slow');
					$("#submit_relais_opc").attr("action", baseDir+'modules/dpdfrance/validation.php?dpdfrance_carrier=' + checkedCarrier);
				});
			}
			
			$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).click(function()
			{
				$.when($('#dpdfrance_div_relais_header,#dpdfrance_lignerelais0,#dpdfrance_lignerelais1,#dpdfrance_lignerelais2,#dpdfrance_lignerelais3,#dpdfrance_lignerelais4').show('fast')).done(function()
				{
					$("#tr_carrier_dpdfrance_relais").html(dpdfrance_relais_response);
					$("#tr_carrier_dpdfrance_relais").fadeIn('slow');
					$("#submit_relais_opc").attr("action", baseDir+'modules/dpdfrance/validation.php?dpdfrance_carrier=' + checkedCarrier);
				});
			});

			$("input[name='id_carrier']").change(function()
			{
				if (!$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked')){
					$("#tr_carrier_dpdfrance_relais").fadeOut('fast');
				}
			});
		}
		else
		{
			if ($('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked'))
				$("#dpdfrance_div_relais_header").fadeIn('slow');
			
			$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).click(function(){
				$("#dpdfrance_div_relais_header").fadeIn('slow');
			});
							
			$("input[name='id_carrier']").change(function(){
				if (!$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked'))
					$("#dpdfrance_div_relais_header").fadeOut('fast');
			});
		}
	});
	{/literal}
}
else
{
	{literal}
	$(document).ready(function(){
		checkedCarrier = $("input[name*='id_carrier']:checked").val();
		if ($("#dpdfrance_div_relais_error").length==0){
			var i;
			var tabInput = document.getElementsByName("dpdfrance_lignerelais");
			var n = 5;
			
			for (i=0; i<n; i++){
				document.getElementById("dpdfrance_lignerelais").id = 'dpdfrance_lignerelais'+i;
			}

			if ($('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked')){
				document.getElementById('dpdfrance_lignerelais0').style.display = "";
				document.getElementById('dpdfrance_lignerelais1').style.display = "";
				document.getElementById('dpdfrance_lignerelais2').style.display = "";
				document.getElementById('dpdfrance_lignerelais3').style.display = "";
				document.getElementById('dpdfrance_lignerelais4').style.display = "";
				$('#dpdfrance_div_relais_header').fadeIn('fast', function() {});
				$("#submit_relais_opc").attr("action", baseDir+'modules/dpdfrance/validation.php?dpdfrance_carrier=' + checkedCarrier);
			}else{
				document.getElementById('dpdfrance_lignerelais0').style.display = "none";
				document.getElementById('dpdfrance_lignerelais1').style.display = "none";
				document.getElementById('dpdfrance_lignerelais2').style.display = "none";
				document.getElementById('dpdfrance_lignerelais3').style.display = "none";
				document.getElementById('dpdfrance_lignerelais4').style.display = "none";
				$('#dpdfrance_div_relais_header').fadeOut('fast', function() {});
			}

			$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).click(function(){
				document.getElementById('dpdfrance_lignerelais0').style.display = "";
				document.getElementById('dpdfrance_lignerelais1').style.display = "";
				document.getElementById('dpdfrance_lignerelais2').style.display = "";
				document.getElementById('dpdfrance_lignerelais3').style.display = "";
				document.getElementById('dpdfrance_lignerelais4').style.display = "";
				$('#dpdfrance_div_relais_header').fadeIn('fast', function() {});
				$("#submit_relais_opc").attr("action", baseDir+'modules/dpdfrance/validation.php?dpdfrance_carrier=' + checkedCarrier);
			});

			$("input[name='id_carrier']").change(function(){
				if (!$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked')){
					document.getElementById('dpdfrance_lignerelais0').style.display = "none";
					document.getElementById('dpdfrance_lignerelais1').style.display = "none";
					document.getElementById('dpdfrance_lignerelais2').style.display = "none";
					document.getElementById('dpdfrance_lignerelais3').style.display = "none";
					document.getElementById('dpdfrance_lignerelais4').style.display = "none";
					$('#dpdfrance_div_relais_header').fadeOut('fast', function() {});
				}
			});
		}
		else
		{
			if ($('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked'))
				$("#dpdfrance_div_relais_header").fadeIn('slow');
			
			$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).click(function(){
				$("#dpdfrance_div_relais_header").fadeIn('slow');
			});
							
			$("input[name='id_carrier']").change(function(){
				if (!$('#id_carrier' + {/literal}{$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}{literal}).attr('checked'))
					$("#dpdfrance_div_relais_header").fadeOut('fast');
			});
		}
	});
{/literal}
}
</script>

<tr id="dpdfrance_div_relais_header" style="display:none;">
	{if isset($error)}
		<td colspan="4" id="dpdfrance_div_relais_error" class="alert warning"> {$error|escape:'htmlall':'UTF-8'}</td>
			<tr>
				<td colspan="4" style="display:none;">&nbsp;</td>
			</tr>
	{else}
		<td colspan="4">
			<p style="min-width:540px;">
				{l s='Please select your DPD Relais parcelshop among this list' mod='dpdfrance'}
			</p>
		</td>
	{if $dpdfrance_relais_status == 'error'}
		<tr>
			<td colspan="5" style="padding:0px;"><div class="dpdfrance_relais_error"><p>{l s='It seems that you haven\'t selected a DPD Pickup point, please pick one from this list' mod='dpdfrance'}</p></div></td>
		</tr>
	{/if}
</tr>

{foreach from=$dpdfrance_relais_points item=points name=dpdfranceRelaisLoop} 
<tr id="dpdfrance_lignerelais" style="display:none;">
	<td align="left" class="dpdfrance_logorelais" id="dpdfrance_logorelais">
	</td>
	
	<td align="left" class="dpdfrance_adressepr"><b>{$points.shop_name|escape:'htmlall':'UTF-8'}</b><br>{$points.address1|escape:'htmlall':'UTF-8'}<br>{$points.postal_code|escape:'htmlall':'UTF-8'} {$points.city|escape:'htmlall':'UTF-8'}
	</td>
		
	<td align="right" class="dpdfrance_popinpr">
		<a class="dpdfrance_notfancy" target="_blank" href="javascript:void(0);" target="_blank" onclick="window.open(&quot;http://www.dpd.fr/dpdrelais/id_{$points.relay_id|escape:'htmlall':'UTF-8'}&quot;,&quot;Votre relais Pickup&quot;,&quot;menubar=no, status=no, scrollbars=no, location=no, toolbar=no, width=1024, height=640&quot;);return false;">
			<span onMouseOver="javascript:this.style.cursor='pointer';" onMouseOut="javascript:this.style.cursor='auto';">
				</u>{$points.distance|escape:'htmlall':'UTF-8'} km<br/>{l s='More details' mod='dpdfrance'}</u>
			</span>
		</a>
	</td>
	
	<td align="right" class="dpdfrance_relais_radio radio">
		<form method='post' action='{if $ssl}{$base_dir_ssl|escape:'htmlall':'UTF-8'}{else}{$base_dir|escape:'htmlall':'UTF-8'}{/if}modules/dpdfrance/validation.php?dpdfrance_carrier={$dpdfrance_relais_carrier_id|escape:'javascript':'UTF-8'}'>
			{if $dpdfrance_selectedrelay == $points.relay_id}
				<input type='submit' name="dpdfrance_relay_id_opc" id="{$points.relay_id|escape:'htmlall':'UTF-8'}" value="{$points.relay_id|escape:'htmlall':'UTF-8'}" class="dpdfrance_relais_buttonok" onMouseOver="javascript:this.style.cursor='pointer';" onMouseOut="javascript:this.style.cursor='auto';">				</input>
			{else}
				<input type='submit' name="dpdfrance_relay_id_opc" id="{$points.relay_id|escape:'htmlall':'UTF-8'}" value="{$points.relay_id|escape:'htmlall':'UTF-8'}" class="dpdfrance_relais_buttonchoose" onMouseOver="javascript:this.style.cursor='pointer';" onMouseOut="javascript:this.style.cursor='auto';">				</input>
			{/if}
		</form>	
	</td>
</tr>

</td>

{/foreach}

{/if}
</div>
</td>