import 'package:flutter/material.dart';

class SliderModel {
  String imageAssetPath;
  String title;
  String desc;
  Color backgroundColour;

  SliderModel(
      {this.imageAssetPath, this.title, this.desc, this.backgroundColour});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  void setBackgroundColor(Color color) {
    backgroundColour = color;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }

  Color getBackgroundColor() {
    return backgroundColour;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc(
      "Browse local activities, entertainment, restaurant and bars , and get exclusive offers on the go ");
  sliderModel.setTitle("Discover what's nearby");
//  sliderModel.setImageAssetPath("assets/discover.png");
  sliderModel.setImageAssetPath("assets/location.flr");
  sliderModel.setBackgroundColor(Color(0xFF6600CC));
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc(
      "Build your perfect deal and unlock hundreds of additional discounts and perks across London");
  sliderModel.setTitle("Combine offers");
  //sliderModel.setImageAssetPath("assets/combine.png");
  sliderModel.setImageAssetPath("assets/combine_offers.flr");
  sliderModel.setBackgroundColor(Color(0xFF9833FF));
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc(
      "Get inspired, discover places in your area, and make the most of your day");
  sliderModel.setTitle("Unlock additional discounts");
//  sliderModel.setImageAssetPath("assets/unlock.png");
  sliderModel.setImageAssetPath("assets/unlock_discounts.flr");
  sliderModel.setBackgroundColor(Color(0xFFFFCC06));
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
