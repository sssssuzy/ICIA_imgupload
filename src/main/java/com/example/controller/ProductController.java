package com.example.controller;

import java.io.File;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.example.domain.Criteria;
import com.example.domain.PageMaker;
import com.example.domain.ProductVO;
import com.example.mapper.ProductMapper;
import com.example.service.ProductService;

@Controller
public class ProductController {

	@Resource(name = "uploadPath")
	String path;

	@Autowired
	ProductService service;

	@Autowired
	ProductMapper mapper;

	@RequestMapping("getAttach")
	@ResponseBody
	public List<String> getAttach(String pcode){		
		return mapper.getAttach(pcode);
	}
	
	@RequestMapping("read")
	public String read(Model model, String pcode) {
		model.addAttribute("vo", mapper.read(pcode));
		return "read";
	}

	@RequestMapping("list")
	public String list(Model model, Criteria cri) {
		cri.setPerPageNum(8);

		PageMaker pm = new PageMaker();
		pm.setDisplayPageNum(8);
		pm.setCri(cri);
		pm.setTotalCount(mapper.totalCount(cri));

		model.addAttribute("pm", pm);
		model.addAttribute("cri", cri);
		model.addAttribute("list", mapper.list(cri));
		return "list";
	}

	@RequestMapping("delete")
	public String delete(String pcode) {
		ProductVO vo = mapper.read(pcode);
		// 기존 이미지 삭제
		if (vo.getImage() != null) {
			new File(path + "/" + vo.getImage()).delete();
		}
		mapper.delete(pcode);
		return "redirect:list";
	}

	@RequestMapping("insert")
	public String insert(Model model) {
		String lastCode = mapper.lastCode();
		int last = Integer.parseInt(lastCode.substring(1)) + 1;
		String code = "P" + last;
		model.addAttribute("code", code);
		return "insert";
	}

	@RequestMapping(value = "update", method = RequestMethod.POST)
	public String update(ProductVO vo, MultipartHttpServletRequest multi) throws Exception {
		ProductVO oldVO = mapper.read(vo.getPcode());

		// 파일 업로드
		MultipartFile file = multi.getFile("file");
		if (!file.isEmpty()) { // 파일이 비어있지 않으면
			String image = System.currentTimeMillis() + "_" + file.getOriginalFilename();
			file.transferTo(new File(path + "/" + image));
			vo.setImage(image);

			// 기존 이미지 삭제
			if (oldVO.getImage() != null) {
				new File(path + "/" + oldVO.getImage()).delete();
			}
		} else {
			vo.setImage(oldVO.getImage());
		}		
		service.update(vo);
		return "redirect:list";
	}

	@RequestMapping(value = "insert", method = RequestMethod.POST)
	public String insert(ProductVO vo, MultipartHttpServletRequest multi) throws Exception {
		// 파일 업로드
		MultipartFile file = multi.getFile("file");
		if (!file.isEmpty()) { // 파일이 비어있지 않으면
			String image = System.currentTimeMillis() + "_" + file.getOriginalFilename();
			file.transferTo(new File(path + "/" + image));
			vo.setImage(image);

		}
		mapper.insert(vo);
		return "redirect:list";
	}
}