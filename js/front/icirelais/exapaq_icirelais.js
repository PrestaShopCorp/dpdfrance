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

 function initialize(mapid,lat,longti,baseurl) {
    var latlng = new google.maps.LatLng(lat, longti);
	
    var myOptions = {
      zoom 		: 15,
      center 	: latlng,
      mapTypeId : google.maps.MapTypeId.ROADMAP,
    };
		
    var map = new google.maps.Map(document.getElementById(mapid), myOptions);
	
    var marker = new google.maps.Marker({
	   icon 		: baseurl+"/modules/exapaq/img/front/icirelais/logo-max-png.png",
       position 	: latlng,
	   animation 	: google.maps.Animation.DROP,
       map			: map
    });
}

function openDialog(id,mapid,lat,longti,baseurl){
	$("#header").css('z-index', 0);
	$("#filter").fadeIn(150, function() {$("#"+id).fadeIn(150);});
	window.setTimeout(function () {initialize(mapid,lat,longti,baseurl)},200);
}