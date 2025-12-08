package org.zerock.controller;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.apache.tika.Tika;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.zerock.domain.AttachFileDTO;

import lombok.extern.log4j.Log4j2;
import net.coobird.thumbnailator.Thumbnailator;

@Controller
@Log4j2
public class UploadController {
	
	
	@GetMapping("/uploadForm")
	public void uploadForm() {}
	
	@PreAuthorize("isAuthenticated()")
	@GetMapping("/uploadAjax")
	public void uploadAjax() {
		File uploadPath = new File("C:\\upload", "temp");
		if (!uploadPath.exists()) {uploadPath.mkdirs();}
	}
	
	@PostMapping("/uploadFormAction")
	public void uploadFormPost(MultipartFile[] uploadFile, Model model) {
		String uploadFolder = "c:\\upload";
		
		for(MultipartFile multipartFile: uploadFile) {
			log.info("===========================================================");
			log.info("Upload File Name : " + multipartFile.getOriginalFilename());
			log.info("Upload file size : " + multipartFile.getSize());
			log.info("===========================================================");
			
			File saveFile = new File(uploadFolder, multipartFile.getOriginalFilename());
			
			try {
				multipartFile.transferTo(saveFile);
			} catch (Exception e) {
				log.error(e.getMessage());
			} // END try-catch
			
		}// END FOR
	}// END @PostMapping("/uploadFormAction")
	
	/* First form of PostMapping /uploadAjaxAction
	 * @PostMapping("/uploadAjaxAction") public void uploadAjaxPost(MultipartFile[]
	 * uploadFile) { log.
	 * info("update ajax post ==================================================");
	 * 
	 * String uploadFolder = "c:\\upload"; for (MultipartFile multipartFile:
	 * uploadFile ) { String uploadFileName = multipartFile.getOriginalFilename();
	 * 
	 * // For IE File Path - No longer necessary //uploadFileName =
	 * uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
	 * 
	 * log.info("===========================================================");
	 * log.info("Upload File Name : " + multipartFile.getOriginalFilename());
	 * log.info("Upload file size : " + multipartFile.getSize());
	 * log.info("Only file name   : " + uploadFileName);
	 * log.info("===========================================================");
	 * 
	 * File saveFile = new File(uploadFolder, uploadFileName);
	 * 
	 * try { multipartFile.transferTo(saveFile); } catch (Exception e) {
	 * log.error(e.getMessage()); } // END try-catch
	 * 
	 * }// END FOR }// END @PostMapping("/uploadAjaxAction")
	 */	
	
	/*
	 * Second form of PostMapping /uploadAjaxAction
	 * 
	 * @PostMapping("/uploadAjaxAction") public void uploadAjaxPost(MultipartFile[]
	 * uploadFile) { String uploadFolder = "C:\\upload";
	 * 
	 * // make folder File uploadPath = new File(uploadFolder, getFolder()); if
	 * (!uploadPath.exists()) { uploadPath.mkdirs(); }
	 * 
	 * for (MultipartFile multipartFile: uploadFile ) { String uploadFileName =
	 * multipartFile.getOriginalFilename();
	 * 
	 * // For IE File Path - No longer necessary //uploadFileName =
	 * //uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
	 * 
	 * //UUID를 생성하고 파일이름을 UUID + 이전이름으로 변경함. UUID uuid = UUID.randomUUID();
	 * uploadFileName = uuid.toString() + "_" + uploadFileName;
	 * 
	 * try { File saveFile = new File(uploadPath,uploadFileName);
	 * multipartFile.transferTo(saveFile); if(checkImageType(saveFile)) { // 썸내일은 파일
	 * 이름 앞에 s_를 추가하여 저장함. FileOutputStream thumbnail = new FileOutputStream(new
	 * File(uploadPath,"s_" + uploadFileName)); // 썸내일 이미지를 생성함
	 * Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail,
	 * 100,100); thumbnail.close(); }
	 * log.info("===========================================================");
	 * log.info("Upload Path      : " + uploadPath); log.info("Upload File Name : "
	 * + multipartFile.getOriginalFilename()); log.info("Upload File Size : " +
	 * (double)(multipartFile.getSize())/1024/1024); log.info("saveFile name    : "
	 * + uploadFileName); log.info("Final Path + Name: " + saveFile);
	 * log.info("==========================================================="); }
	 * catch (Exception e) { log.error(e.getMessage()); } // END try-catch }// END
	 * FOR }// END @PostMapping("/uploadAjaxAction")
	 */	

	@PostMapping(value = "/uploadAjaxAction", produces = MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody // Sending Data to Front-End using AJAX  (Async Java, Async XML)
	// We now use REST, because we don't use  XML anymore
	public ResponseEntity<List<AttachFileDTO>> uploadAjaxPost(MultipartFile[] uploadFile) {
		//INIT----------------------------------------------------------------------------
		List<AttachFileDTO> list = new ArrayList<>();
		String uploadFolder = "C:\\upload";
		String uploadFolderPath = getFolder();
		
		// make folder--------------------------------------------------------------------
		File uploadPath = new File(uploadFolder, uploadFolderPath);
		if (!uploadPath.exists()) { uploadPath.mkdirs(); }
		
		//각 파일 처리------------------------------------------------------------------------
		for (MultipartFile multipartFile: uploadFile ) { 
			//FileName 받기-----------------------------------------------------------------
			String uploadFileName = multipartFile.getOriginalFilename();

			//AttachFileDTO INIT------------------------------------------------------------
			AttachFileDTO attachDTO = new AttachFileDTO();
			attachDTO.setFileName(uploadFileName);
			
			// For IE File Path - No longer necessary----------------------------------------
			//uploadFileName = uploadFileName.substring(uploadFileName.lastIndexOf("\\") + 1);
			
			//UUID를 생성하고 파일이름을 UUID + 이전이름으로 변경함.--------------------------------------
			UUID uuid = UUID.randomUUID();
			uploadFileName = uuid.toString() + "_" + uploadFileName;
			
			try { 
				File saveFile = new File(uploadPath,uploadFileName);
				multipartFile.transferTo(saveFile);
				
				attachDTO.setUuid(uuid.toString());
				attachDTO.setUploadPath(uploadFolderPath);
				
				// 이미지인지 확인함
				if(checkImageType(saveFile)) {
					// 이미지인것을 attachDTO에 저장함
					attachDTO.setImage(true);
					// 썸내일은 파일 이름 앞에 s_를 추가하여 저장함.
					FileOutputStream thumbnail = new FileOutputStream(new File(uploadPath,"s_" + uploadFileName));
					// 썸내일 이미지를 생성함
					Thumbnailator.createThumbnail(multipartFile.getInputStream(), thumbnail, 100,100);
					thumbnail.close();
				}
				
				list.add(attachDTO);
				
				log.info("===========================================================");
				log.info("Upload Path    : " + attachDTO.getUploadPath());
				log.info("UUID           : " + attachDTO.getUuid());
				log.info("File Name      : " + attachDTO.getFileName());
				log.info("isImage        : " + attachDTO.isImage());
				log.info("File Size (MB) : " + (double)(multipartFile.getSize())/1024/1024);
				/*
				 * log.info("Upload Path      : " + uploadPath); log.info("Upload File Name : "
				 * + multipartFile.getOriginalFilename()); log.info("Upload File Size : " +
				 * (double)(multipartFile.getSize())/1024/1024); log.info("saveFile name    : "
				 * + uploadFileName); log.info("has Thumbnail    : " + attachDTO.isImage());
				 * log.info("Final Path + Name: " + saveFile);
				 */
				log.info("===========================================================");
			} catch (Exception e) {
				log.error(e.getMessage()); 
			} // END try-catch
		}// END FOR 
		
		return new ResponseEntity<>(list, HttpStatus.OK);
	}// END @PostMapping("/uploadAjaxAction")
	
	
	@GetMapping("/display")	
	@ResponseBody
	public ResponseEntity<byte[]> getFile(String fileName) {
		// get dir to img
		File file = new File("c:\\upload\\" + fileName);
		
		// an array to save img into
		ResponseEntity<byte[]> result = null;

		log.info("===========================================================");
		log.info("fileName: " + fileName);
		log.info("file    : " + file);
		log.info("===========================================================");
		
		try {
			HttpHeaders header = new HttpHeaders();														//Create a HttpHeader
			//header.add("Content-Type", Files.probeContentType(file.toPath()));							//Get the header of the file
			header.add("Content-Type", new Tika().detect(file));							//Get the header of the file
			result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);	//Assign the header
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return result;
	}
	
	@GetMapping(value="/download", produces = MediaType.APPLICATION_OCTET_STREAM_VALUE)
	@ResponseBody
	public ResponseEntity<Resource> downloadFile(@RequestHeader("User-Agent") String userAgent, String fileName){
		Resource resource = new FileSystemResource("c:\\upload\\" + fileName);
		
		if (!resource.exists()) {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}

		String resourceName = resource.getFilename();

		// remove UUID
		String resourceOriginalName = resourceName.substring(resourceName.indexOf("_") + 1);

		HttpHeaders headers = new HttpHeaders();
		try {
			String downloadName = null;
			downloadName = new String(resourceOriginalName.getBytes("UTF-8"), "ISO-8859-1");
			log.info("downloadName: " + downloadName);
			headers.add("Content-Disposition", "attachment; filename=" + downloadName);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource, headers, HttpStatus.OK);
	}
	
	@PreAuthorize("isAuthenticated()")
	@PostMapping("/deleteFile")
	@ResponseBody
	public ResponseEntity<String> deleteFile(String fileName, String type){
		
		File file;
		
		try {
			file = new File("C:\\upload\\" + URLDecoder.decode(fileName, "UTF-8"));
			
			file.delete();
			
			if(type.equals("image")) {
				String largeFileName = file.getAbsolutePath().replace("s_","");
				log.info("===========================================================");
				log.info("Thumbnail: " + fileName);
				log.info("File Name: " + largeFileName);
				log.info("===========================================================");
				file = new File(largeFileName);
				file.delete();
			}
		}catch (UnsupportedEncodingException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
		return new ResponseEntity<String>("Deleted", HttpStatus.OK);
	}
		
	
	
	/*====================================================================
	 * Helper functions -> Should be within Service or Util, not here!!!!!
	 *====================================================================*/
	// Date formatting 년-월-일 형식
	private String getFolder() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		String str = sdf.format(date);
		return str.replace("-", File.separator);
	}
	//CheckImageType
	private boolean checkImageType(File file) {
		try {
			// 파일의 contentType구하기
			//String contentType = Files.probeContentType(file.toPath());
			String contentType = new Tika().detect(file);
			// contentType이 "image"로 시작하면 이미지로 판단. true리턴
			return contentType.startsWith("image");
		} catch (IOException e) {
			e.printStackTrace();
		}
		return false;
	}
}
