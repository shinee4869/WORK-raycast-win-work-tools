import {
  ActionPanel,
  Action,
  List,
  showToast,
  Toast,
  Clipboard,
  popToRoot,
} from "@raycast/api";
import { useState, useEffect } from "react";
import axios from "axios";
import qs from "qs";

type AddressItem = {
  roadAddr: string;
  zipNo: string;
};

export default function Command() {
  const [query, setQuery] = useState<string>("");
  const [results, setResults] = useState<AddressItem[]>([]);
  const [isLoading, setIsLoading] = useState<boolean>(false);

  useEffect(() => {
    if (query.length === 0) {
      setResults([]);
      return;
    }

    const fetchData = async () => {
      setIsLoading(true);
      try {
        const keyword = query.replace(/ /g, "+");
        const queryParams = qs.stringify({
          currentPage: "1",
          countPerPage: "10",
          resultType: "json",
          keyword: keyword,
          confmKey: "U01TX0FVVEgyMDIxMDQxMTA5Mzc0NTExMTAzNTQ=",
        });

        const url = `https://www.juso.go.kr/addrlink/addrLinkApi.do?${queryParams}`;
        const response = await axios.get(url);
        const data = response.data.results.juso;
        setResults(data || []);
      } catch (error) {
        await showToast({
          style: Toast.Style.Failure,
          title: "주소 조회 실패",
          message: error instanceof Error ? error.message : "알 수 없는 오류",
        });
      } finally {
        setIsLoading(false);
      }
    };

    fetchData();
  }, [query]);

  const handleCopy = async (text: string) => {
    await Clipboard.copy(text);
    await showToast({
      style: Toast.Style.Success,
      title: "클립보드에 복사되었습니다 ✅",
      message: text,
    });
    await popToRoot();
  };

  return (
    <List
      searchBarPlaceholder="주소를 입력하세요"
      onSearchTextChange={setQuery}
      isLoading={isLoading}
      throttle
    >
      {results.map((item, index) => (
        <List.Item
          key={index}
          title={item.roadAddr}
          subtitle={item.zipNo}
          actions={
            <ActionPanel>
              <Action
                title="주소 복사"
                onAction={() => handleCopy(`${item.roadAddr} (${item.zipNo})`)}
              />
              <Action
                title="도로명 주소만 복사"
                onAction={() => handleCopy(item.roadAddr)}
              />
              <Action
                title="우편번호만 복사"
                onAction={() => handleCopy(item.zipNo)}
              />
            </ActionPanel>
          }
        />
      ))}
    </List>
  );
}
