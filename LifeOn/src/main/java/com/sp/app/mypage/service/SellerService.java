package com.sp.app.mypage.service;

import com.sp.app.auction.response.prize.PrizeDetailRep;
import com.sp.app.common.StorageService;
import com.sp.app.exception.StorageException;
import com.sp.app.lounge.model.FreeBoard;
import com.sp.app.mapper.AuctionMapper;
import com.sp.app.mapper.SellerMapper;
import com.sp.app.mypage.controller.dto.request.SellerRequest;
import com.sp.app.mypage.controller.dto.response.CategoryResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class SellerService implements SellerServiceInterFace {

    private final AuctionMapper auctionMapper;
    private final SellerMapper sellerMapper;
    private final StorageService storageService;


    @Override
    public CategoryResponse findByAllCategory() {

        CategoryResponse resp = new CategoryResponse();

        resp.setSmallCategory(Optional.ofNullable(auctionMapper.findByAllCategorySmall(new HashMap<>())).orElse(Collections.emptyList()));
        resp.setBigCategory(Optional.ofNullable(auctionMapper.findByAllCategoryBig()).orElse(Collections.emptyList()));

        return resp;
    }

    @Override
    @Transactional
    public void insertPrize(SellerRequest dto, String uploadPath) throws Exception {
        try {


            String startDate;
            String endDate;

            int startHour = Integer.parseInt(dto.getStartDateHH());
            int endHour = Integer.parseInt(dto.getEndDateHH());

            if (dto.getStartDateTime().equalsIgnoreCase("pm") && startHour < 12) {
                startHour += 12;
            }

            if (dto.getEndDateTime().equalsIgnoreCase("pm") && endHour < 12) {
                endHour += 12;
            }

            startDate = String.format("%s %02d:%02d:00", dto.getStartDate(), startHour, Integer.parseInt(dto.getStartDateMM()));
            endDate = String.format("%s %02d:%02d:00", dto.getEndDate(), endHour, Integer.parseInt(dto.getEndDateMM()));

            dto.setStartDate(startDate);
            dto.setEndDate(endDate);


            //썸네일
            String filename = storageService.uploadFileToServer(dto.getThumbnailFile(), uploadPath);
            dto.setThumbnail(filename);

            sellerMapper.insertPrize(dto);

            if (!dto.getSelectFile().isEmpty()) {
                insertFile(dto, uploadPath);
            }

        } catch (Exception e) {
            log.info("insertBoard : " + e);

            throw e;
        }
    }

    // TODO 데이터 가져올때 진행현황 갱신 필요
    // 비슷한 코드 AuctionService.java 에 있음
    @Override
    public List<PrizeDetailRep> findBySellerList(Map<String, Object> map) {

        try {

            return sellerMapper.findBySellerList(map);

        } catch (Exception e) {
            log.info("findBySellerList : ", e);
        }

        return null;
    }

    @Override
    public int dataCount(Map<String, Object> map) throws Exception {
        try {
            return sellerMapper.dataCount(map);
        } catch (Exception e) {
            log.info("dataCount : ", e);
        }
        return 0;
    }

    @Override
    public PrizeDetailRep findBySellerDetail(Map<String, Object> map) {
        try {
            return auctionMapper.findByPrize(map);
        } catch (Exception e) {
            log.info("findBySellerDetail : ", e);
        }
        return null;
    }




    @Override
    @Transactional
    public void deleteSeller(long pNum,String upPath) throws Exception {

        try {

            deleteUploadFile(pNum,upPath);


            sellerMapper.deleteSeller(pNum);


        } catch (Exception e) {
            log.info("deleteSeller : ", e);
            throw e;
        }

    }

    @Override
    public void deleteFileEM(String upPath) {
        List<PrizeDetailRep> listFile = null;
        try {
//            listFile = sellerMapper.findByPictureListEM();
            List<String> picName = storageService.listAllFiles(upPath);



        }catch (Exception e) {
            log.info("deleteFileEM : ", e);
        }
    }


    protected void deleteUploadFile(long num,String upPath) throws Exception {
        List<PrizeDetailRep> listFile = null;
        try {
            listFile = sellerMapper.findByPictureList(num);
            List<String> picName = new ArrayList<>();

            if (listFile != null) {
                for (PrizeDetailRep prizeDetailRep : listFile) {
                    picName.add(prizeDetailRep.getThumbnail());
                }
                picName.add(listFile.get(0).getPrName());
                for (String s : picName) {
                    storageService.deleteFile(upPath, s);
                }


            }

        } catch (Exception e) {
            log.info("deleteUploadFile : ", e);
            throw e;
        }

    }



    protected void insertFile(SellerRequest dto, String uploadPath) throws Exception {
        for (MultipartFile mf : dto.getSelectFile()) {
            try {

                String saveFilename = Objects.requireNonNull(storageService.uploadFileToServer(mf, uploadPath));

                dto.setPicPath(saveFilename);

                //auctionMapper.updateFile(dto);
                sellerMapper.insertFile(dto);

            } catch (NullPointerException | StorageException ignored) {
            } catch (Exception e) {
                throw e;
            }
        }
    }
}
