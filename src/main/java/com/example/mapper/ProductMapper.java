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
	//��ǰ�� ���� �̹��� ���� �̸��� ��������
	public List<String> getAttach(String pcode);
	//��ǰ ������ ���� ���ϵ� ���� �� �ٽ� �����ϱ� ���� �޼���
	public void delAttach(String pcode);
	public void addAttach(@Param("image") String image,@Param("pcode") String pcode);	
}
