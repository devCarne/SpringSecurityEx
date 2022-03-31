package stu.kms.WebSecurity.task;

import lombok.Setter;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import stu.kms.WebSecurity.domain.BoardAttachVO;
import stu.kms.WebSecurity.mapper.BoardAttachMapper;

import java.io.File;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

@Component
@Slf4j
public class FileCheckTask {

    @Setter(onMethod_ = @Autowired)
    private BoardAttachMapper attachMapper;

//    어제의 날짜를 구하고 폴더 구조로 변환
    private String getFolderYesterday() {
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DATE, -1);

        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String str = sdf.format(calendar.getTime());

        return str.replace("-", File.separator);
    }

    //매일 새벽 2시 동작
    @Scheduled(cron = "0 0 2 * * *")
    public void checkFiles() throws Exception {
        log.warn("File Check Task run....................");
        log.warn(String.valueOf(new Date()));

        List<BoardAttachVO> oldFiles = attachMapper.getOldFiles();

        //지난 날짜의 파일 가져오기
        List<Path> oldFilesPaths = oldFiles.stream().map(vo ->
                Paths.get("C:\\upload", vo.getUploadPath(), vo.getUuid() + "_" + vo.getFileName())).collect(Collectors.toList());

        //썸네일 파일도 가져오기
        oldFiles.stream().filter(vo -> vo.isFileType() == true).map(vo ->
                Paths.get("C:\\upload", vo.getUploadPath(), "s_" + vo.getUuid() + "_" + vo.getFileName())).forEach(path -> oldFilesPaths.add(path));

        oldFilesPaths.forEach(path -> log.warn(path.toString()));

        //삭제 대상 폴더
        File targetDir = Paths.get("C:\\upload", getFolderYesterday()).toFile();
        //삭제 대상 폴더 내의 파일이 DB에 등록되어 있지 않은 경우 삭제 대상으로 등록
        File[] targetFiles = targetDir.listFiles(file -> !oldFilesPaths.contains(file.toPath()));

        if (targetFiles != null) {
            for (File file : targetFiles) {
                file.delete();
            }
        }
    }
}
