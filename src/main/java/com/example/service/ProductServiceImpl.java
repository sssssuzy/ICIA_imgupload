package com.example.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.domain.ProductVO;
import com.example.mapper.ProductMapper;

@Service
public class ProductServiceImpl implements ProductService{

	@Autowired
	ProductMapper mapper;
	
	@Override
	public void update(ProductVO vo) {
		mapper.update(vo);
		
		//���� ÷�����ϵ� delete
		mapper.delAttach(vo.getPcode());
		
		//÷�����ϵ� insert
		String[] images = vo.getImages();
		if(images==null) return;
		for(String fullName:images){
			mapper.addAttach(fullName, vo.getPcode());
		}
	}
}
