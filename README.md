โครงสร้าง provider ที่ออกแบบ (มีกี่ตัว ทำหน้าที่อะไร)
* allTradersProvider - โหลด mock trader ผ่าน TraderRepository
* availableTagsProvider - รายการ tag ทั้งหมดที่เลือกได้ใน Filter Bottom Sheet
* filterTagsProvider - ค่า filter ที่ apply แล้วจริง — ตัวนี้คือ global keep-alive ใช้กรอง trader list 
* draftFilterTagsProvider - ค่า filter ระหว่างที่ผู้ใช้ยังแตะชิปอยู่ใน sheet ยังไม่ apply จนกว่าจะกด Confirm
* filteredTradersProvider - ค่า filter จาก allTradersProvider + filterTagsProvider 
* filteredTraderCountProvider - นับจำนวน ที่ได้จาก filteredTradersProvider โชว์ใน badge


เหตุผลที่เลือก State Management Pattern (Riverpod Notifier)
* ไม่ต้องส่งค่าข้ามไปข้ามมา Widget ทั้งสองหน้าสื่อสารผ่าน Provider กลางโดยตรง ไม่ต้องส่งผ่าน Constructor
* ปิดหน้าต่างแล้วค่าไม่หาย (Keep-Alive)
* แยก Business Logic ออกจาก UI
"# trader-portfolio-list-with-filter" 
