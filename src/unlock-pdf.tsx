import {
  ActionPanel,
  Action,
  Form,
  showToast,
  Toast,
  popToRoot,
} from "@raycast/api";
import { useState } from "react";
import { exec } from "child_process";
import presetPasswords from "./data/passwords.json";

type PasswordEntry = {
  label: string;
  value: string;
};

const PASSWORDS: PasswordEntry[] = [
  ...presetPasswords,
  { label: "그 외", value: "custom" },
];

export default function Command() {
  const [isLoading, setIsLoading] = useState(false);
  const [selectedFiles, setSelectedFiles] = useState<string[]>([]);
  const [selectedPassword, setSelectedPassword] = useState<string>(
    PASSWORDS[0].value
  );
  const [customPassword, setCustomPassword] = useState<string>("");

  async function handleSubmit() {
    const inputPath = selectedFiles[0];

    if (!inputPath) {
      await showToast({
        style: Toast.Style.Failure,
        title: "PDF 파일을 선택해주세요",
      });
      return;
    }

    const password =
      selectedPassword === "custom" ? customPassword : selectedPassword;

    if (!password) {
      await showToast({
        style: Toast.Style.Failure,
        title: "비밀번호를 입력해주세요",
      });
      return;
    }

    setIsLoading(true);

    const outputPath = inputPath.replace(/\.pdf$/i, "_unlocked.pdf");
    const command = `qpdf --password="${password}" --decrypt "${inputPath}" "${outputPath}"`;

    exec(command, async (error, stdout, stderr) => {
      setIsLoading(false);

      if (error) {
        await showToast({
          style: Toast.Style.Failure,
          title: "Unlock 실패",
          message: stderr || error.message,
        });
        return;
      }

      await showToast({
        style: Toast.Style.Success,
        title: "PDF 잠금 해제 완료 ✅",
        message: outputPath,
      });

      await popToRoot();
    });
  }

  return (
    <Form
      isLoading={isLoading}
      enableDrafts={false}
      navigationTitle="Unlock PDF"
      actions={
        <ActionPanel>
          <Action.SubmitForm title="잠금 해제" onSubmit={handleSubmit} />
        </ActionPanel>
      }
    >
      {/* ESC 키 정상 작동을 위한 포커스 트랩 */}
      <Form.TextField
        id="dummy"
        title=""
        placeholder="PDF 비밀번호 해제 도구"
        value=""
        onChange={() => undefined}
      />

      <Form.Separator />

      <Form.FilePicker
        id="file"
        title="PDF 파일 선택"
        allowMultipleSelection={false}
        value={selectedFiles}
        onChange={setSelectedFiles}
      />

      <Form.Dropdown
        id="passwordChoice"
        title="비밀번호 선택"
        value={selectedPassword}
        onChange={setSelectedPassword}
      >
        {PASSWORDS.map((pw) => (
          <Form.Dropdown.Item
            key={pw.value}
            value={pw.value}
            title={pw.label}
          />
        ))}
      </Form.Dropdown>

      {selectedPassword === "custom" && (
        <Form.PasswordField
          id="customPassword"
          title="비밀번호 직접 입력"
          placeholder="비밀번호를 입력하세요"
          value={customPassword}
          onChange={setCustomPassword}
        />
      )}

      <Form.Description
        title="실행 방법"
        text="파일 선택 후 비밀번호를 고르고 Ctrl+Enter 를 누르세요."
      />
    </Form>
  );
}
