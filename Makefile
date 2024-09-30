SRCS=Src/*.c

CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

CFLAGS = -g -O2 -Wall
CFLAGS += -T ./STM32F446RE_FLASH.ld
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += --specs=nosys.specs
CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -DSTM32F446xx
CFLAGS += -I.
CFLAGS += -I./Inc
CFLAGS += -I./Drivers/STM32F4xx_HAL_Driver/Inc
CFLAGS += -I./Drivers/CMSIS/Include
CFLAGS += -I./Drivers/CMSIS/Device/ST/STM32F4xx/Include

SRCS += ./Drivers/STM32F4xx_HAL_Driver/Src/*.c
SRCS += ./startup/startup_stm32f446xx.s

.PHONY: main

all: main

main: main.elf

main.elf: $(SRCS)
	$(CC) $(CFLAGS) $^ -o $@
	$(OBJCOPY) -O binary main.elf main.bin

flash: main
	st-flash write main.bin 0x08000000

flashmass: main
	cp main.bin /Volumes/NOD_F446RE

clean:
	rm -f main.elf main.bin
