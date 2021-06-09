package com.example.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.example.domain.Criteria;
import com.example.domain.ProductVO;

public interface ProductMapper {
	public List<ProductVO> list(Criteria cri);
	public String lastCode();
	public void insert(ProductVO vo);	
	public int totalCount(Criteria cri);
	public ProductVO read(String pcode);
	public void update(ProductVO vo);
	public void delete(String pcode);
	//상품에 대한 이미지 파일 이름들 가져오기
	public List<String> getAttach(String pcode);
	//상품 수정시 기존 파일들 삭제 후 다시 저장하기 위한 메서드
	public void delAttach(String pcode);
	public void addAttach(@Param("image") String image,@Param("pcode") String pcode);	
}
