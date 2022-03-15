<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="file.FileDAO" %>
<%@ page import="java.io.File" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="bbs.BbsDAO" %>
<%@ page import="java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bbs" class="bbs.Bbs" scope="page" />
<jsp:setProperty name="bbs" property="bbsTitle" />
<jsp:setProperty name="bbs" property="bbsContent" />
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>JSP Web Site</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		
		BbsDAO bbsDAO = new BbsDAO();
		Bbs bbs = new Bbs();
		bbs.setBbsID(bbsDAO.getNewNext());
		int bbsID = bbs.getBbsID();
		String directory = application.getRealPath("/upload/"+bbsID+"/");
		
		File targetDir = new File(directory);
		if(!targetDir.exists()){
			targetDir.mkdirs();
		}
		
		int maxSize = 1024 * 1024 * 500;
		String encoding = "UTF-8";
		
		MultipartRequest multipartRequest
		= new MultipartRequest(request, directory, maxSize, encoding,
						new DefaultFileRenamePolicy());
		
		String fileName = multipartRequest.getOriginalFileName("file");
		String fileRealName = multipartRequest.getFilesystemName("file");
		
		String bbsTitle = multipartRequest.getParameter("bbsTitle");
		String bbsContent = multipartRequest.getParameter("bbsContent");
		bbs.setBbsTitle(bbsTitle);
		bbs.setBbsContent(bbsContent);
		
		if(userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		} else {
			if (bbs.getBbsTitle() == null || bbs.getBbsContent() == null) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('입력하지 않은 사항이 있습니다.')");
					script.println("history.back()");
					script.println("</script");
				} else {
					
					System.out.println("getNewNext before bbsDAO.write : " + bbs.getBbsID());
					int result = bbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent());
					
					new FileDAO().upload(fileName, fileRealName, bbs.getBbsID());
					out.write("filename : " + fileName + "<br>");
					out.write("realfilename : " + fileName + "<br>");
					
					if (result == -1) {
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('글쓰기에 실패했습니다.')");
						script.println("history.back()");
						script.println("</script>");
					}
					else {
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("location.href = 'bbs.jsp'");
						script.println("</script>");
					}
				}
		}
	%>
</body>
</html>
