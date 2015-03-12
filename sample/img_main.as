/*@
***summary***
Copyright (c) 2007 Frank@2solo.cn
URL:www.2solo.cn
Create date:2008.03.16
Last modified by:frank
Last modified at:2008.03.28
File version:v1.02
Path:
Info:文档类(document class)
Location:shanghai,china

Exif2-2
http://www.exif.org/Exif2-2.PDF
*/
package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestHeader;
	import flash.utils.*;

	import flash.text.TextField;
	import flash.text.TextFieldType;
	import fl.controls.UIScrollBar;
	import fl.containers.ScrollPane;
	import fl.controls.ScrollPolicy;

	import flash.system.Security;
	import nt.imagine.exif.ExifExtractor;

	public class img_main extends Sprite {
		private var uloader:URLLoader=new URLLoader();
		private var imgloader:Loader=new Loader();
		private var thumbLoader:Loader=new Loader();
		private var headlen;
		private var exifMgr;
		private var getBtn=new btn();
		private var sp:ScrollPane;
		private var urlTxt:TextField;
		private var listTxt:TextField;
		private var uiSb:UIScrollBar=new UIScrollBar();
		private var load_mc=new uploading_mc();

		public function img_main() {
			init();
		}

		private function init():void {
			iniMC();
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			uloader.addEventListener(Event.COMPLETE,completeHandler);
			uloader.dataFormat=URLLoaderDataFormat.BINARY;
			addChild(load_mc);
			load_mc.visible=false;
		}
		/*
		开始下载
		*/
		private function goLoad() {
			load_mc.visible=true;
			load_mc.txt.text="Getting image!";
			if (sp!=null) {
				setChildIndex(load_mc,getChildIndex(sp));
			} else {
				setChildIndex(load_mc,4);
			}
			var request:URLRequest=new URLRequest(urlTxt.text);
			uloader.load(request);
		}
		/*
		元素设定
		*/
		private function iniMC() {
			getBtn.addEventListener(MouseEvent.CLICK,btnClick);
			getBtn.x=590;
			getBtn.y=20;
			urlTxt=new TextField  ;
			urlTxt.border=true;
			urlTxt.text="pic/3.jpg";
			urlTxt.x=17;
			urlTxt.y=12;
			urlTxt.width=526;
			urlTxt.height=20;
			urlTxt.type=TextFieldType.INPUT;
			listTxt=new TextField  ;
			listTxt.border=true;
			listTxt.x=10;
			listTxt.y=160;
			listTxt.width=146;
			listTxt.height=330;
			uiSb.scrollTarget=listTxt;
			uiSb.direction="vertical";
			uiSb.setSize(listTxt.width,listTxt.height);
			uiSb.move(listTxt.x + listTxt.width,listTxt.y);
			addChild(urlTxt);
			addChild(listTxt);
			addChild(uiSb);
			addChild(getBtn);
		}
		private function btnClick(evt) {
			goLoad();
		}
		private function completeHandler(evt:Event):void {
			imgloader.loadBytes(uloader.data);
			exifMgr=new ExifExtractor(uloader);
			if (exifMgr.hasthumb) {
				thumbLoader.loadBytes(exifMgr.getThumb());
				thumbLoader.x=10;
				thumbLoader.y=40;
				addChild(thumbLoader);
			} else if (thumbLoader.content != null) {
				thumbLoader.unload();
				removeChild(thumbLoader);
			}
			createScrollPane();
			listTxt.text="";
			var logArr=exifMgr.getLog();
			for (var i=0; i < logArr.length; i++) {
				listTxt.appendText("\n" + logArr[i]);

			}
			var tempObj=exifMgr.getTagByTag(271);//提取一个代码为271的标签
			if (tempObj != null) {
				trace(exifMgr.getTagByTag(271).CN + "|" + exifMgr.getTagByTag(271).values);
			}
			var temp_arr=exifMgr.getAllTag();//提取全部标签

			for (i=0; i < temp_arr.length; i++) {
				listTxt.appendText("\n" + i + temp_arr[i].CN + "|" + temp_arr[i].values);

			}
			uiSb.update();
			load_mc.visible=false;
		}
		private function createScrollPane():void {
			sp=new ScrollPane  ;
			sp.addEventListener(MouseEvent.CLICK,spComplete);
			sp.move(180,40);
			sp.setSize(450,450);
			sp.scrollDrag=true;
			sp.source=imgloader;
			addChild(sp);
		}
		private function spComplete(e:Event):void {
			sp.refreshPane();
			sp.update();
		}
	}
}