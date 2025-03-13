package com.sp.app.mypage.controller.dto.request;

import lombok.Getter;
import lombok.Setter;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Setter
@Getter
public class SellerRequest {

    private long userId;
    private String prName;
    private String startDate;
    private String startDateTime;
    private String startDateHH;
    private String startDateMM;
    private String endDate;
    private String endDateTime;
    private String endDateHH;
    private String endDateMM;
    private int prPrice;
    private int mainCategory;
    private int subCategory;
    private String content;
    private String dealType;
    private String  thumbnail;
    private MultipartFile thumbnailFile;
    private String picPath;

    private long fnum; // 파일번호
    private List<MultipartFile> selectFile;




}
