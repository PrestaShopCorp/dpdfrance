<?php
/**
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
 * @author    EXAPAQ S.A.S. <support@icirelais.com>
 * @copyright 2015 EXAPAQ S.A.S.
 * @license   http://opensource.org/licenses/afl-3.0.php  Academic Free License (AFL 3.0)
 */

class AdminExapaq extends AdminTab
{
	private $module = 'exapaq';

	public $controller_type;

	public function __construct()
	{
		$this->name = 'exapaq';

		if (version_compare(_PS_VERSION_, '1.5.0.0 ', '>='))
		{
			$this->multishop_context = Shop::CONTEXT_ALL | Shop::CONTEXT_GROUP | Shop::CONTEXT_SHOP;
			$this->multishop_context_group = Shop::CONTEXT_GROUP;
		}

		parent::__construct();

		/* Backward compatibility */
		if (_PS_VERSION_ < '1.5')
			require_once(_PS_MODULE_DIR_.$this->name.'/backward_compatibility/backward.php');
		if (_PS_VERSION_ < '1.4')
			require_once(_PS_MODULE_DIR_.$this->module.'/'.Language::getIsoById((int)$this->context->language->id).'.php');
	}
	/* Converts country ISO code to EXA-Print format */
	public static function getIsoCodebyIdCountry($idcountry)
	{
		$sql = '
		SELECT `iso_code`
		FROM `'._DB_PREFIX_.'country`
		WHERE `id_country` = \''.pSQL($idcountry).'\'';

		$result = Db::getInstance(_PS_USE_SQL_SLAVE_)->getRow($sql);

		$isops = array('DE', 'AD', 'AT', 'BE', 'BA', 'BG', 'HR', 'DK', 'ES', 'EE', 'FI', 'FR', 'GB', 'GR', 'GG', 'HU', 'IM', 'IE', 'IT', 'JE', 'LV', 'LI', 'LT', 'LU', 'NO', 'NL', 'PL', 'PT', 'CZ', 'RO', 'RS', 'SK', 'SI', 'SE', 'CH');
		$isoep = array('D', 'AND', 'A', 'B', 'BA', 'BG', 'CRO', 'DK', 'E', 'EST', 'SF', 'F', 'GB', 'GR', 'GG', 'H', 'IM', 'IRL', 'I', 'JE', 'LET', 'LIE', 'LIT', 'L', 'N', 'NL', 'PL', 'P', 'CZ', 'RO', 'RS', 'SK', 'SLO', 'S', 'CH');

		if (in_array($result['iso_code'], $isops)) // Si le code ISO est européen, on le convertit au format Exa-Print
			$code_iso = str_replace($isops, $isoep, $result['iso_code']);
		else
			$code_iso = str_replace($result['iso_code'], 'INT', $result['iso_code']); // Si le code ISO n'est pas européen, on le passe en 'INT' (intercontinental)
	return $code_iso;
	}
	/* Get order IDs by status */
	public static function getOrderIdsByStatus($id_order_state)
	{
		$result = Db::getInstance()->ExecuteS('
		  SELECT id_order
		  FROM '._DB_PREFIX_.'orders o
		  WHERE '.(int)$id_order_state.' = (
		   SELECT id_order_state
		   FROM '._DB_PREFIX_.'order_history oh
		   WHERE oh.id_order = o .id_order
		   ORDER BY date_add DESC, id_order_history DESC
		   LIMIT 1
		  )
		  ORDER BY invoice_date ASC');
		$orders = array();
		foreach ($result as $order)
			$orders[] = (int)$order['id_order'];
		return $orders;
	}
	/* Get all orders but statuses cancelled, delivered, error */
	public static function getAllOrders($id_shop)
	{
		if ($id_shop == 0)
			$id_shop = 'LIKE "%"';
		else
			$id_shop = '= '.$id_shop;

		$sql14 = '	SELECT id_order
					FROM '._DB_PREFIX_.'orders o
					WHERE (
						SELECT id_order_state
						FROM '._DB_PREFIX_.'order_history oh
						WHERE oh.id_order = o .id_order
						ORDER BY date_add DESC, id_order_history DESC
						LIMIT 1)
					NOT IN ('.(int)Configuration::get('EXAPAQ_ETAPE_LIVRE', null, null, (int)$id_shop).',0,5,6,7,8)
					ORDER BY invoice_date ASC';

		$sql15 = '	SELECT id_order
					FROM '._DB_PREFIX_.'orders o
					WHERE `current_state` NOT IN('.(int)Configuration::get('EXAPAQ_ETAPE_LIVRE', null, null, (int)$id_shop).',0,5,6,7,8) AND o.id_shop '.$id_shop.'
					ORDER BY invoice_date ASC';

		if (_PS_VERSION_ < '1.5')
			$result = Db::getInstance()->ExecuteS($sql14);
		else
			$result = Db::getInstance()->ExecuteS($sql15);

		$orders = array();
		foreach ($result as $order)
			$orders[] = (int)$order['id_order'];
		return $orders;
	}
	/* Formats GSM numbers */
	public function formatGSM($input_tel)
	{
		$gsm_dest = str_replace(array(' ', '.', '-', ',', ';', '/', '\\', '(', ')'), '', $input_tel);
		$gsm_dest = str_replace('+33', '0', $gsm_dest);
		if (Tools::substr($gsm_dest, 0, 2) == 33) // Chrome autofill fix
			$gsm_dest = substr_replace($gsm_dest, '0', 0, 2);
		return $gsm_dest;
	}

	public function display()
	{
		if (_PS_VERSION_ < '1.4')
			echo '<script type="text/javascript" src="../modules/'.$this->name.'/js/admin/jquery/jquery-1.4.3.min.js"></script>';
		echo '	<link rel="stylesheet" type="text/css" href="../modules/'.$this->name.'/js/admin/jquery/plugins/fancybox/jquery.fancybox-1.3.4.css" media="screen"/>
				<script type="text/javascript" src="../modules/'.$this->name.'/js/admin/jquery/plugins/fancybox/jquery.fancybox-1.3.4.js"></script>
				<script type="text/javascript" src="../modules/'.$this->name.'/js/admin/jquery/plugins/marquee/jquery.marquee.min.js"></script>';
		echo "	<script type='text/javascript'>
				$(document).ready(function(){
					$('.marquee').marquee({
						duration: 20000,
						gap: 50,
						delayBeforeStart: 0,
						direction: 'left',
						duplicated: true,
						pauseOnHover: true
					});
				$('a.popup').fancybox({ 			
						'hideOnContentClick': true,
						'padding'			: 0,
						'overlayColor'		:'#D3D3D3',
						'overlayOpacity'	: 0.7,
						'width'				: 1024,
						'height'			: 640,
						'type'				:'iframe'
						});
					jQuery.expr[':'].contains = function(a, i, m) { 
						return jQuery(a).text().toUpperCase().indexOf(m[3].toUpperCase()) >= 0; 
					};
				$(\"#tableFilter\").keyup(function () {
					//split the current value of tableFilter
					var data = this.value.split(\";\");
					//create a jquery object of the rows
					var jo = $(\"#fbody\").find(\"tr\");
					if (this.value == \"\") {
						jo.show();
						return;
					}
					//hide all the rows
					jo.hide();

					//Recusively filter the jquery object to get results.
					jo.filter(function (i, v) {
						var t = $(this);
						for (var d = 0; d < data.length; ++d) {
							if (t.is(\":contains('\" + data[d] + \"')\")) {
								return true;
							}
						}
						return false;
					})
					//show the rows that match.
					.show();
				}).focus(function () {
					this.value = \"\";
					$(this).css({
						\"color\": \"black\"
					});
					$(this).unbind('focus');
				}).css({
					\"color\": \"#C0C0C0\"
				});
				});
				</script>";

		echo "<script type='text/javascript'>
				 function checkallboxes(ele) {
					 var checkboxes = document.getElementsByName('checkbox[]');
					 if (ele.checked) {
						 for (var i = 0; i < checkboxes.length; i++) {
							 if (checkboxes[i].type == 'checkbox') {
								 checkboxes[i].checked = true;
							 }
						 }
					 } else {
						 for (var i = 0; i < checkboxes.length; i++) {
							 if (checkboxes[i].type == 'checkbox') {
								 checkboxes[i].checked = false;
							 }
						 }
					 }
				 }
			</script>";

		// Update delivered orders
		if (Tools::getIsset('updateDeliveredOrders'))
		{
			if (Tools::getIsset('checkbox'))
				$orders = Tools::getValue('checkbox');
			if (!empty($orders))
			{ // Test sur requete SQL OK
				$sql = 'SELECT 	O.`id_order` AS id_order
						FROM 	'._DB_PREFIX_.'orders AS O, 
								'._DB_PREFIX_.'carrier AS CA 
						WHERE 	CA.id_carrier=O.id_carrier AND 
								id_order IN ('.implode(',', $orders).')';

				$orderlist = Db::getInstance()->ExecuteS($sql);

				if (!empty($orderlist))
				{ // Check if there are EXAPAQ orders
					foreach ($orderlist as $orders)
					{
						$id_order = $orders['id_order'];
						if (Validate::isLoadedObject($order = new Order($id_order)))
						{
							if (_PS_VERSION_ < '1.5')
								$order->id_shop = '';
							$history = new OrderHistory();
							$history->id_order = (int)$id_order;
							$history->changeIdOrderState(Configuration::get('EXAPAQ_ETAPE_LIVRE', null, null, (int)$order->id_shop), $id_order);
							$history->id_employee = (int)$this->context->employee->id;
							$history->addWithemail();
						}
					}
					echo '<div class="conf confirm">'.$this->l('Delivered orders statuses were updated').'</div>';
				}
				else
					echo '<div class="alert warn">'.$this->l('No EXAPAQ trackings to generate.').'</div>';
			}
			else
				echo '<div class="alert warn">'.$this->l('No order selected.').'</div>';
		}

		// Update shipped orders
		if (Tools::getIsset('updateShippedOrders'))
		{
			if (Tools::getIsset('checkbox'))
				$orders = Tools::getValue('checkbox');
			if (!empty($orders))
			{
				$sql = 'SELECT 	O.`id_order` AS id_order
						FROM 	'._DB_PREFIX_.'orders AS O, 
								'._DB_PREFIX_.'carrier AS CA 
						WHERE 	CA.id_carrier=O.id_carrier AND 
								id_order IN ('.implode(',', $orders).')';

				$orderlist = Db::getInstance()->ExecuteS($sql);

				if (!empty($orderlist))
				{ // Check if there are EXAPAQ orders
					foreach ($orderlist as $orders)
					{
						$id_order = $orders['id_order'];
						if (Validate::isLoadedObject($order = new Order($id_order)))
						{
							if (_PS_VERSION_ < '1.5')
							{
								$internalref_cleaned = $order->id;
								$order->id_shop = '';
							}
							else
								$internalref_cleaned = $order->reference;

							switch (self::getService($order->id_cart, $order->id_carrier))
							{
								case 'PRE':
									$compte_chargeur = Configuration::get('EXAPAQ_PREDICT_SHIPPER_CODE', null, null, (int)$order->id_shop);
									$depot_code = Configuration::get('EXAPAQ_PREDICT_DEPOT_CODE', null, null, (int)$order->id_shop);
									break;
								case 'REL':
									$compte_chargeur = Configuration::get('EXAPAQ_ICIRELAIS_SHIPPER_CODE', null, null, (int)$order->id_shop);
									$depot_code = Configuration::get('EXAPAQ_ICIRELAIS_DEPOT_CODE', null, null, (int)$order->id_shop);
									break;
								default:
									$compte_chargeur = Configuration::get('EXAPAQ_CLASSIC_SHIPPER_CODE', null, null, (int)$order->id_shop);
									$depot_code = Configuration::get('EXAPAQ_CLASSIC_DEPOT_CODE', null, null, (int)$order->id_shop);
									break;
							}

							$url = 'http://webtrace.exapaq.com/exa-webtrace/webclients.aspx?verknr='.$internalref_cleaned.'&kund_mandnr='.$depot_code.'&kundenr='.$compte_chargeur.'&cmd=VERKNR_SEARCH';

							$customer = new Customer((int)$order->id_customer);

							$order->shipping_number = $internalref_cleaned.'&kund_mandnr='.$depot_code.'&kundenr='.$compte_chargeur;
							Db::getInstance()->execute('UPDATE '._DB_PREFIX_.'orders SET shipping_number = "'.$order->shipping_number.'" WHERE id_order = "'.$id_order.'"');
							if (_PS_VERSION_ >= '1.5')
								Db::getInstance()->execute('UPDATE '._DB_PREFIX_.'order_carrier SET tracking_number = "'.$order->shipping_number.'" WHERE id_order = "'.$id_order.'"');
							$order->update();

							$history = new OrderHistory();
							$history->id_order = (int)$id_order;
							$history->changeIdOrderState(Configuration::get('EXAPAQ_ETAPE_EXPEDIEE', null, null, (int)$order->id_shop), $id_order);
							$history->id_employee = (int)$this->context->employee->id;
							$carrier = new Carrier((int)$order->id_carrier, (int)$this->context->language->id);
							if (_PS_VERSION_ < '1.5')
								$template_vars = array('{followup}' => $url, '{firstname}' => $customer->firstname, '{lastname}' => $customer->lastname, '{id_order}' => (int)$order->id);
							else
								$template_vars = array('{followup}' => $url, '{firstname}' => $customer->firstname, '{lastname}' => $customer->lastname, '{order_name}' => $order->reference, '{id_order}' => (int)$order->id);

							$subject = 'Votre commande est expédiée par EXAPAQ';
							if (!$history->addWithemail(true, $template_vars))
								$this->_errors[] = Tools::displayError('an error occurred while changing status or was unable to send e-mail to the customer');

							if (!Validate::isLoadedObject($customer) || !Validate::isLoadedObject($carrier))
								die(Tools::displayError());

							Mail::Send((int)$order->id_lang, 'in_transit', $subject, $template_vars, $customer->email, $customer->firstname.' '.$customer->lastname);
						}
					}
					echo '<div class="conf confirm">'.$this->l('Shipped orders statuses were updated and tracking numbers added.').'</div>';
				}
				else
					echo '<div class="alert warn">'.$this->l('No trackings to generate.').'</div>';
			}
			else
				echo '<div class="alert warn">'.$this->l('No order selected.').'</div>';
		}

		// Exporter les commandes sélectionnées
		if (Tools::getIsset('exportOrders'))
		{
			$fieldlist = array('O.`id_order`', 'AD.`lastname`', 'AD.`firstname`', 'AD.`postcode`', 'AD.`city`', 'CL.`iso_code`', 'C.`email`');
			if (Tools::getIsset('checkbox'))
			{
				$orders = Tools::getValue('checkbox');

				$liste_expeditions = 'O.id_order IN ('.implode(',', $orders).')';
				if (!empty($orders))
				{ // Test sur requete SQL OK
					$sql = 'SELECT	'.implode(', ', $fieldlist).'
							FROM 	'._DB_PREFIX_.'orders AS O, 
									'._DB_PREFIX_.'carrier AS CA, 
									'._DB_PREFIX_.'customer AS C, 
									'._DB_PREFIX_.'address AS AD, 
									'._DB_PREFIX_.'country AS CL
							WHERE 	O.id_address_delivery=AD.id_address AND
									C.id_customer=O.id_customer AND 
									CL.id_country=AD.id_country AND 
									CA.id_carrier=O.id_carrier AND 
									('.$liste_expeditions.')
							ORDER BY id_order DESC';

					$orderlist = Db::getInstance()->ExecuteS($sql);

					if (!empty($orderlist))
					{ // Test sur la présence de commandes
						// Creation fichier et récup des données expéditeur
						$record = new ExaPrint();
						foreach ($orderlist as $order_var)
						{
							// Récupération des données nécessaires
							$order = new Order($order_var['id_order']);
							$nom_exp = Configuration::get('EXAPAQ_NOM_EXP', null, null, (int)$order->id_shop);			// Raison sociale expéditeur
							$address_exp = Configuration::get('EXAPAQ_ADDRESS_EXP', null, null, (int)$order->id_shop);	// Adresse
							$address2_exp = Configuration::get('EXAPAQ_ADDRESS2_EXP', null, null, (int)$order->id_shop);	// Complément d'adresse
							$cp_exp = Configuration::get('EXAPAQ_CP_EXP', null, null, (int)$order->id_shop);				// Code postal
							$ville_exp = Configuration::get('EXAPAQ_VILLE_EXP', null, null, (int)$order->id_shop);		// Ville
							$code_pays_exp = 'F';																			// Code pays
							$tel_exp = Configuration::get('EXAPAQ_TEL_EXP', null, null, (int)$order->id_shop);			// Téléphone
							$email_exp = Configuration::get('EXAPAQ_EMAIL_EXP', null, null, (int)$order->id_shop);		// E-mail
							$gsm_exp = Configuration::get('EXAPAQ_GSM_EXP', null, null, (int)$order->id_shop);			// N° GSM

							// Retro compatibilité PS 1.4 et inf.
							if (_PS_VERSION_ < '1.5')
								$order->reference = $order->id;

							$customer = new Customer($order->id_customer);
							$address_invoice = new Address($order->id_address_invoice, (int)$this->context->language->id);
							$address_delivery = new Address($order->id_address_delivery, (int)$this->context->language->id);
							$code_pays_dest = self::getIsoCodebyIdCountry((int)$address_delivery->id_country);
							$instr_liv_cleaned = str_replace (array("\r\n", "\n", "\r", "\t"), ' ', $address_delivery->other);
							$type = self::getService($order->id_cart, $order->id_carrier);
							$relay_id = Tools::substr($address_delivery->company, -7, 6);
							$tel_dest = Db::getInstance()->getValue('SELECT gsm_dest FROM '._DB_PREFIX_.'exapaq_france WHERE id_cart ="'.$order->id_cart.'"');
							if ($tel_dest == '')
								$tel_dest = (($address_delivery->phone_mobile) ? $address_delivery->phone_mobile : (($address_invoice->phone_mobile) ? $address_invoice->phone_mobile : (($address_delivery->phone) ? $address_delivery->phone : (($address_invoice->phone) ? $address_invoice->phone : ''))));

							if (Tools::strtolower(Configuration::get('PS_WEIGHT_UNIT', null, null, (int)$order->id_shop)) == 'kg')
								$poids = (int)($order->getTotalWeight() * 100);

							if (Tools::strtolower(Configuration::get('PS_WEIGHT_UNIT', null, null, (int)$order->id_shop)) == 'g')
								$poids = (int)($order->getTotalWeight() * 0.1);

							switch (self::getService($order->id_cart, $order->id_carrier))
							{
								case 'PRE':
									$compte_chargeur = Configuration::get('EXAPAQ_PREDICT_SHIPPER_CODE', null, null, (int)$order->id_shop);
									break;
								case 'REL':
									$compte_chargeur = Configuration::get('EXAPAQ_ICIRELAIS_SHIPPER_CODE', null, null, (int)$order->id_shop);
									break;
								default:
									$compte_chargeur = Configuration::get('EXAPAQ_CLASSIC_SHIPPER_CODE', null, null, (int)$order->id_shop);
									break;
							}

							// Structure du fichier d'interface EXAPAQ unifié
							$record->add($order->reference, 0, 35);														//	Référence client N°1 - Référence Commande Prestashop 1.5
							$record->add(str_pad((int)$poids, 8, '0', STR_PAD_LEFT), 37, 8);							//	Poids du colis sur 8 caractères
							if ($type == 'REL')
							{
								$record->add($address_delivery->lastname, 60, 35);    									//	Nom du destinataire
								$record->add($address_delivery->firstname, 95, 35);    									//	Prénom du destinataire
							}
							else
							{
								$record->add($address_delivery->lastname.' '.$address_delivery->firstname, 60, 35);    	//	Nom et prénom du destinataire
								$record->add($address_delivery->company, 95, 35);    									//	Complément d'adresse 1
							}
							$record->add($address_delivery->address2, 130, 140);   										//	Complément d’adresse 2 a 5
							$record->add($address_delivery->postcode, 270, 10);    										//	Code postal
							$record->add($address_delivery->city, 280, 35);     										//	Ville
							$record->add($address_delivery->address1, 325, 35);    										//	Rue
							$record->add('', 360, 10);    																//	Filler
							$record->add($code_pays_dest, 370, 3);          											//	Code Pays destinataire
							$record->add(self::formatGSM($tel_dest), 373, 30);        									//	Téléphone
							$record->add($nom_exp, 418, 35);        													//	Nom expéditeur
							$record->add($address2_exp, 453, 35);       												//	Complément d’adresse 1
							$record->add($cp_exp, 628, 10);         													//	Code postal
							$record->add($ville_exp, 638, 35);        													//	Ville
							$record->add($address_exp, 683, 35);       													//	Rue
							$record->add($code_pays_exp, 728, 3);       												//	Code Pays
							$record->add($tel_exp, 731, 30);        													//	Tél.
							$record->add(Tools::substr($instr_liv_cleaned, 0, 36), 761, 35);        					//	Instructions de livraison 1
							$record->add(Tools::substr($instr_liv_cleaned, 35, 36), 796, 35);        					//	Instructions de livraison 2
							$record->add(Tools::substr($instr_liv_cleaned, 70, 36), 831, 35);        					//	Instructions de livraison 3
							$record->add(Tools::substr($instr_liv_cleaned, 105, 36), 866, 35);        					//	Instructions de livraison 4
							$record->add(date('d/m/Y'), 901, 10);  														//	Date d'expédition théorique
							$record->add(str_pad($compte_chargeur, 8, '0', STR_PAD_LEFT), 911, 8); 						//	N° de compte chargeur EXAPAQ
							$record->add($order->id, 919, 35);															//	Code à barres
							$record->add($order->id, 954, 35);        													//	N° de commande - Id Order Prestashop
							if (in_array($order->id, Tools::getValue('advalorem')))
								$record->add(str_pad(number_format($order->total_paid, 2, '.', ''), 9, '0', STR_PAD_LEFT), 1018, 9); // Montant valeur colis
							$record->add($order->id, 1035, 35);       													//	Référence client N°2 - Id Order Prestashop
							$record->add($email_exp, 1116, 80);        													//	E-mail expéditeur
							$record->add($gsm_exp, 1196, 35);        													//	GSM expéditeur
							$record->add($customer->email, 1231, 80);      												//	E-mail destinataire
							if ($type == 'PRE' || $type == 'REL')
								$record->add(self::formatGSM($tel_dest), 1311, 35);  									//	GSM destinataire
							else
								$record->add($tel_dest, 1311, 35);  													//	GSM destinataire
							if ($type == 'REL')
								$record->add($relay_id, 1442, 8);         												//	Identifiant de l'espace ICI relais
							if ($type == 'PRE' && $tel_dest && $code_pays_dest == 'F')
								$record->add('+', 1568, 1);																//	Flag Predict
							$record->add($address_delivery->lastname, 1569, 35);    									//	Nom de famille du destinataire
							$record->addLine();
						}
						$record->display();
					}
					else
						echo '<div class="alert warn">'.$this->l('No orders to export.').'</div>';
				}
				else
					echo '<div class="alert warn">'.$this->l('No orders to export.').'</div>';
			}
			else
				echo '<div class="alert warn">'.$this->l('No order selected.').'</div>';
		}

		// Affichage
		// Message d'erreur si Cargo ou N° Agence manquant
		if (Configuration::get('EXAPAQ_PARAM', null, null, (int)$this->context->shop->id) != 1)
		{
			echo '<div class="error">'.$this->l('Warning! Your EXAPAQ Depot code and contract number are missing. You must configure the EXAPAQ plugin in order to use the export and tracking features.').'</div>';
			exit;
		}
		// Flux RSS
		if (_PS_VERSION_ < '1.4')
			$rss = @simplexml_load_string(file_get_contents('http://www.exapaq.com/flux_info_exapaq.xml'));
		else
			$rss = @simplexml_load_string(Tools::file_get_contents('http://www.exapaq.com/flux_info_exapaq.xml'));

		if ($rss != '')
		{
			echo '<fieldset><legend><a href="javascript:void(0)" onclick="$(&quot;#zonemarquee&quot;).toggle(&quot;fast&quot;, function() {});"><img src="../modules/exapaq/img/admin/rss_icon.png" />'.$this->l('EXAPAQ News (show/hide)').'</a></legend>'; // Titre et cadre
			echo '<div id="zonemarquee"><div id="marquee" class="marquee">';
			foreach ($rss->channel->item as $item)
				echo '<strong style="color:red;">'.$item->category.' > '.$item->title.' : </strong> '.$item->description.'&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;';
			echo '</div></div></fieldset><br/>';
		}
		// Fin RSS

		echo '<link rel="stylesheet" type="text/css" href="../modules/'.$this->name.'/css/admin/AdminExapaq.css"/>';
		echo '<fieldset><legend><img src="../modules/'.$this->name.'/img/admin/admin.png"/>'.$this->l('EXAPAQ deliveries management').'</legend>'; // Titre et cadre

		self::recupOrders();

		echo '<p>
				<input type="submit" class="button" name="exportOrders'.$this->table.'" value="'.$this->l('Export selected orders to EXA-Print').'" />
				<input type="submit" class="button" name="updateShippedOrders'.$this->table.'" value="'.$this->l('Update shipped orders').'" />
				<input type="submit" class="button" name="updateDeliveredOrders'.$this->table.'" value="'.$this->l('Update delivered orders').'" />
			</p>
			</form>';
		echo '</fieldset>';
	}
	/* Get delivery service for a cart ID & checks if id_carrier matches */
	public function getService($id_cart, $id_carrier)
	{
		$sql = Db::getInstance()->getRow('SELECT `service` FROM `'._DB_PREFIX_.'exapaq_france` WHERE `id_cart` = '.(int)$id_cart.' AND `id_carrier` = '.(int)$id_carrier);
		return $sql['service'];
	}

	/* Get eligible orders and builds up display */
	public function recupOrders()
	{
		$statuses_array = array();
		$statuses = OrderState::getOrderStates((int)$this->context->language->id);

		foreach ($statuses as $status)
			$statuses_array[$status['id_order_state']] = $status['name'];
			$fieldlist = array('O.`id_order`', 'O.`id_cart`', 'AD.`lastname`', 'AD.`firstname`', 'AD.`postcode`', 'AD.`city`', 'CL.`iso_code`', 'C.`email`', 'CA.`name`');
			$orders = AdminExapaq::getAllOrders((int)Tools::substr($this->context->cookie->shopContext, 2));
			$liste_expeditions = 'O.id_order IN ('.implode(',', $orders).')';

			$predict_carrier_log = $classic_carrier_log = $icirelais_carrier_log = $europe_carrier_log = '';

			if (Configuration::get('EXAPAQ_PREDICT_CARRIER_LOG', null, null, (int)$this->context->shop->id))
				$predict_carrier_log = 'CA.id_carrier IN ('.implode(',', explode('|', Tools::substr(Configuration::get('EXAPAQ_PREDICT_CARRIER_LOG', null, null, (int)$this->context->shop->id), 1))).') OR ';
			if (Configuration::get('EXAPAQ_CLASSIC_CARRIER_LOG', null, null, (int)$this->context->shop->id))
				$classic_carrier_log = 'CA.id_carrier IN ('.implode(',', explode('|', Tools::substr(Configuration::get('EXAPAQ_CLASSIC_CARRIER_LOG', null, null, (int)$this->context->shop->id), 1))).') OR ';
			if (Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_LOG', null, null, (int)$this->context->shop->id))
				$icirelais_carrier_log = 'CA.id_carrier IN ('.implode(',', explode('|', Tools::substr(Configuration::get('EXAPAQ_ICIRELAIS_CARRIER_LOG', null, null, (int)$this->context->shop->id), 1))).') OR ';
			$europe_carrier_log = 'CA.name LIKE \'%DPD%\'';

		if (!empty($orders))
		{
			$sql = 'SELECT  '.implode(', ', $fieldlist).'
					FROM 	'._DB_PREFIX_.'orders AS O, 
							'._DB_PREFIX_.'carrier AS CA, 
							'._DB_PREFIX_.'customer AS C, 
							'._DB_PREFIX_.'address AS AD, 
							'._DB_PREFIX_.'country AS CL
					WHERE 	O.id_address_delivery=AD.id_address AND
							C.id_customer=O.id_customer AND 
							CL.id_country=AD.id_country AND 
							CA.id_carrier=O.id_carrier AND 
							('.$predict_carrier_log.$classic_carrier_log.$icirelais_carrier_log.$europe_carrier_log.') AND
							('.$liste_expeditions.')
					ORDER BY id_order DESC';

			$orderlist = Db::getInstance()->ExecuteS($sql);
			if (!empty($orderlist))
			{
				echo '<input id="tableFilter" value="'.$this->l('Search something, separate values with ; ').'"/><img id="filtericon" src="../modules/exapaq/img/admin/search.png"/><br/><br/>
				<form id="exportform" action="index.php?tab=AdminExapaq&token='.$this->token.'" method="POST" enctype="multipart/form-data">	
				';
				echo '<body><table>
						<thead>
							<tr>
								<th class="hcheckexport"><input type="checkbox" onchange="checkallboxes(this)"/></th>
								<th class="hid">ID</th>
								<th class="href">'.$this->l('Reference').'</th>
								<th class="hdate">'.$this->l('Date of order').'</th>
								<th class="hnom">'.$this->l('Recipient').'</th>
								<th class="htype">'.$this->l('Service').'</th>
								<th class="hpr">'.$this->l('Destination').'</th>
								<th class="hpoids">'.$this->l('Weight').'</th>
								<th colspan="2" class="hprix" align="right">'.$this->l('Amount').'<br/><span style="font-size:10px;">'.$this->l('(tick to insure<br/>this parcel)').'</span></th>
								<th class="hstatutcommande" align="center">'.$this->l('Order status').'</th>
								<th class="hstatutcolis" align="center">'.$this->l('Parcel trace').'</th>
							</tr>
						</thead><tbody id="fbody">
				';

				foreach ($orderlist as $order_var)
				{
					$order = new Order($order_var['id_order']);
					$address_delivery = new Address($order->id_address_delivery, (int)$this->context->language->id);
					$orderstate = new OrderHistory($order_var['id_order']);

					switch (self::getService($order->id_cart, $order->id_carrier))
					{
						case 'PRE':
							$type = 'Predict<img src="../modules/exapaq/img/admin/service_predict.png" title="Predict"/>';
							break;
						case 'REL':
							$type = 'ICI relais<img src="../modules/exapaq/img/admin/service_relais.png" title="ICI relais"/>';
							break;
						default:
							$type = 'Classic<img src="../modules/exapaq/img/admin/service_dom.png" title="Classic"/>';
							break;
					}

					if (_PS_VERSION_ < '1.5')
					{
						$current_state_id = ($orderstate->getLastOrderState($order_var['id_order'])->id);
						$current_state_name = $statuses_array[($orderstate->getLastOrderState($order_var['id_order'])->id)];
						$order->reference = $order->id;
						$order->id_shop = '';
					}
					else
					{
						$current_state_id = $order->current_state;
						$current_state_name = $statuses_array[$order->current_state];
					}

					switch ($current_state_id)
					{
						default :
							$dernierstatutcolis = '';
							break;
						case Configuration::get('EXAPAQ_ETAPE_LIVRE', null, null, (int)$order->id_shop):
							$dernierstatutcolis = 'Accéder à la trace';
							break;
						case Configuration::get('EXAPAQ_ETAPE_EXPEDIEE', null, null, (int)$order->id_shop):
							$dernierstatutcolis = '<img src="../modules/exapaq/img/admin/tracking.png" title="Trace du colis"/>';
					}

					// Display orders table
					echo '<tr>';
					if ($current_state_id == Configuration::get('EXAPAQ_ETAPE_EXPEDITION', null, null, (int)$order->id_shop))
						echo '<td><input class="checkbox" type="checkbox" name="checkbox[]" value='.$order->id.' checked="checked"></input></td>';
					else
						echo '<td><input class="checkbox" type="checkbox" name="checkbox[]" value='.$order->id.'></input></td>';
					echo '<td class="id">'.$order->id.'</td>
						<td class="ref">'.$order->reference.'</td>
						<td class="date">'.date('d/m/Y H:i:s', strtotime($order->date_add)).'</td>
						<td class="nom">'.$address_delivery->firstname.' '.$address_delivery->lastname.'</td>
						<td class="type">'.$type.'</td>';

					if (self::getService($order->id_cart, $order->id_carrier) == 'REL')
						echo '<td class="pr"><a class="popup" href="http://www.icirelais.com/pages_module_recherche/point_direct.php?point_id='.Tools::substr($address_delivery->company, -7, 6).'" target="_blank">'.$address_delivery->company.'<br/>'.$address_delivery->postcode.' '.$address_delivery->city.'</a></td>';
					else
						echo '<td class="pr"><a class="popup" href="http://maps.google.com/maps?f=q&hl=fr&geocode=&q='.str_replace(' ', '+', $address_delivery->address1).','.str_replace(' ', '+', $address_delivery->postcode).'+'.str_replace(' ', '+', $address_delivery->city).'&output=embed" target="_blank">'.($address_delivery->company ? $address_delivery->company.'<br/>' : '').$address_delivery->address1.'<br/>'.$address_delivery->postcode.' '.$address_delivery->city.'</a></td>';

					echo '<td class="poids">'.number_format($order->getTotalWeight(), 2, '.', '.').' '.Configuration::get('PS_WEIGHT_UNIT', null, null, (int)$order->id_shop).'</td>
						<td class="prix" align="right">'.number_format($order->total_paid, 2, '.', '.').' €</td>';

					if (Configuration::get('EXAPAQ_AD_VALOREM', null, null, (int)$order->id_shop) == 1)
						echo '<td class="advalorem"><input class="advalorem" type="checkbox" name="advalorem[]" value='.$order->id.' checked="checked"></input></td>';
					else
						echo '<td class="advalorem"><input class="advalorem" type="checkbox" name="advalorem[]" value='.$order->id.'></input></td>';
					echo '<td class="statutcommande" align="center">'.$current_state_name.'</td>
						 <td class="statutcolis" align="center"><a href="javascript:void(0)" onclick="window.open(&apos;http://webtrace.exapaq.com/exa-webtrace/webclients.aspx?verknr='.$order->reference.'&kund_mandnr='.Configuration::get('EXAPAQ_PREDICT_DEPOT_CODE', null, null, (int)$order->id_shop).'&kundenr='.Configuration::get('EXAPAQ_PREDICT_SHIPPER_CODE', null, null, (int)$order->id_shop).'&cmd=VERKNR_SEARCH&apos;,&apos;&apos;,&apos;width=1024,height=768,top=30,left=20&apos;)">'.$dernierstatutcolis.'</td>';
				}
				echo '</tbody></table>';
			}
			else
				echo '<div class="alert warn">'.$this->l('There are no orders.').'</div>';
		}
	}
}

class ExaPrint
{
	var $line;
	var $contenu_fichier;

	public function __construct()
	{
		$this->line = str_pad('', 1634);
		$this->contenu_fichier = '';
	}

	public function add($txt, $position, $length)
	{
		$txt = $this->stripAccents($txt);
		$this->line = substr_replace($this->line, str_pad($txt, $length), $position, $length);
	}

	public function addLine()
	{
		if ($this->contenu_fichier != '')
		{
			$this->contenu_fichier = $this->contenu_fichier."\r\n".$this->line;
			$this->line = '';
			$this->line = str_pad('', 1634);
		}
		else
		{
			$this->contenu_fichier .= $this->line;
			$this->line = '';
			$this->line = str_pad('', 1634);
		}
	}

	public function display()
	{
		ob_clean();
		header('Content-type: application/dat');
		header('Content-Disposition: attachment; filename="EXAPAQ_'.date('dmY-His').'.dat"');
		echo '$VERSION=110'."\r\n";
		echo $this->contenu_fichier."\r\n";
		exit;
	}

	public function stripAccents($str)
	{
		$str = preg_replace('/[\x{00C0}\x{00C1}\x{00C2}\x{00C3}\x{00C4}\x{00C5}]/u', 'A', $str);
		$str = preg_replace('/[\x{0105}\x{0104}\x{00E0}\x{00E1}\x{00E2}\x{00E3}\x{00E4}\x{00E5}]/u', 'a', $str);
		$str = preg_replace('/[\x{00C7}\x{0106}\x{0108}\x{010A}\x{010C}]/u', 'C', $str);
		$str = preg_replace('/[\x{00E7}\x{0107}\x{0109}\x{010B}\x{010D}}]/u', 'c', $str);
		$str = preg_replace('/[\x{010E}\x{0110}]/u', 'D', $str);
		$str = preg_replace('/[\x{010F}\x{0111}]/u', 'd', $str);
		$str = preg_replace('/[\x{00C8}\x{00C9}\x{00CA}\x{00CB}\x{0112}\x{0114}\x{0116}\x{0118}\x{011A}]/u', 'E', $str);
		$str = preg_replace('/[\x{00E8}\x{00E9}\x{00EA}\x{00EB}\x{0113}\x{0115}\x{0117}\x{0119}\x{011B}]/u', 'e', $str);
		$str = preg_replace('/[\x{00CC}\x{00CD}\x{00CE}\x{00CF}\x{0128}\x{012A}\x{012C}\x{012E}\x{0130}]/u', 'I', $str);
		$str = preg_replace('/[\x{00EC}\x{00ED}\x{00EE}\x{00EF}\x{0129}\x{012B}\x{012D}\x{012F}\x{0131}]/u', 'i', $str);
		$str = preg_replace('/[\x{0142}\x{0141}\x{013E}\x{013A}]/u', 'l', $str);
		$str = preg_replace('/[\x{00F1}\x{0148}]/u', 'n', $str);
		$str = preg_replace('/[\x{00D2}\x{00D3}\x{00D4}\x{00D5}\x{00D6}\x{00D8}]/u', 'O', $str);
		$str = preg_replace('/[\x{00F2}\x{00F3}\x{00F4}\x{00F5}\x{00F6}\x{00F8}]/u', 'o', $str);
		$str = preg_replace('/[\x{0159}\x{0155}]/u', 'r', $str);
		$str = preg_replace('/[\x{015B}\x{015A}\x{0161}]/u', 's', $str);
		$str = preg_replace('/[\x{00DF}]/u', 'ss', $str);
		$str = preg_replace('/[\x{0165}]/u', 't', $str);
		$str = preg_replace('/[\x{00D9}\x{00DA}\x{00DB}\x{00DC}\x{016E}\x{0170}\x{0172}]/u', 'U', $str);
		$str = preg_replace('/[\x{00F9}\x{00FA}\x{00FB}\x{00FC}\x{016F}\x{0171}\x{0173}]/u', 'u', $str);
		$str = preg_replace('/[\x{00FD}\x{00FF}]/u', 'y', $str);
		$str = preg_replace('/[\x{017C}\x{017A}\x{017B}\x{0179}\x{017E}]/u', 'z', $str);
		$str = preg_replace('/[\x{00C6}]/u', 'AE', $str);
		$str = preg_replace('/[\x{00E6}]/u', 'ae', $str);
		$str = preg_replace('/[\x{0152}]/u', 'OE', $str);
		$str = preg_replace('/[\x{0153}]/u', 'oe', $str);
		$str = preg_replace('/[\x{0022}\x{0025}\x{0026}\x{0027}\x{00A1}\x{00A2}\x{00A3}\x{00A4}\x{00A5}\x{00A6}\x{00A7}\x{00A8}\x{00AA}\x{00AB}\x{00AC}\x{00AD}\x{00AE}\x{00AF}\x{00B0}\x{00B1}\x{00B2}\x{00B3}\x{00B4}\x{00B5}\x{00B6}\x{00B7}\x{00B8}\x{00BA}\x{00BB}\x{00BC}\x{00BD}\x{00BE}\x{00BF}]/u', ' ', $str);
		return $str;
	}
}
?>