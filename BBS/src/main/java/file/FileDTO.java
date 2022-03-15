package file;

public class FileDTO {

	String fileName;
	String fielRealName;
	
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public String getFielRealName() {
		return fielRealName;
	}
	public void setFielRealName(String fielRealName) {
		this.fielRealName = fielRealName;
	}
	public FileDTO(String fileName, String fielRealName) {
		super();
		this.fileName = fileName;
		this.fielRealName = fielRealName;
	}
}
